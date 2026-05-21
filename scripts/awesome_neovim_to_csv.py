#!/usr/bin/env python3
"""
Parse the awesome-neovim README and write a CSV row per plugin.

For each plugin:
  category, repo_url, github_stars, last_updated, archived(y/n), one_line_desc

Usage:
  python scripts/awesome_neovim_to_csv.py [--input PATH] [--output PATH]

Notes:
  - Reads README.md from rockerBOO/awesome-neovim (downloads if --input not given).
  - Uses the GitHub REST API to enrich repo metadata. Set GITHUB_TOKEN env var
    to avoid the 60/hr unauthenticated rate limit.
  - Non-github.com plugin URLs are still written, but with empty enrichment fields.
"""

from __future__ import annotations

import argparse
import csv
import os
import re
import sys
import time
import urllib.error
import urllib.request
import json
from typing import Optional

README_URL = "https://raw.githubusercontent.com/rockerBOO/awesome-neovim/main/README.md"

# Headings whose contents we should NOT treat as plugin entries.
SKIP_CATEGORIES = {
    "Contents",
    "Wishlist",
    "Resource",
    "Vim",
    "External",
    "Starter Templates",
    "Pre-made Configuration",
}

# Matches: `- [name](url) - description`
# Description is optional; some entries omit it.
LINE_RE = re.compile(r"^\s*[-*]\s*\[([^\]]+)\]\(([^)]+)\)\s*(?:-\s*(.*))?$")
GITHUB_REPO_RE = re.compile(
    r"^https?://github\.com/([^/\s#?]+)/([^/\s#?]+?)(?:\.git)?/?(?:[#?].*)?$"
)


def http_get_json(url: str, token: Optional[str]) -> Optional[dict]:
    req = urllib.request.Request(url, headers={
        "Accept": "application/vnd.github+json",
        "User-Agent": "awesome-neovim-csv-script",
    })
    if token:
        req.add_header("Authorization", f"Bearer {token}")
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            return json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        if e.code == 403 and "rate limit" in (e.reason or "").lower():
            # Try waiting a moment for secondary rate limit; otherwise return None.
            reset = e.headers.get("X-RateLimit-Reset")
            if reset:
                wait = max(0, int(reset) - int(time.time())) + 1
                if wait <= 60:
                    time.sleep(wait)
                    return http_get_json(url, token)
        sys.stderr.write(f"  HTTP {e.code} for {url}: {e.reason}\n")
        return None
    except Exception as e:
        sys.stderr.write(f"  error fetching {url}: {e}\n")
        return None


def download_readme(path: str) -> None:
    sys.stderr.write(f"Downloading README to {path}...\n")
    req = urllib.request.Request(README_URL, headers={"User-Agent": "script"})
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = resp.read()
    with open(path, "wb") as f:
        f.write(data)


def parse_readme(text: str):
    """Yield (category, name, url, description) tuples."""
    top_category = None
    sub_category = None
    in_skip = False

    for raw in text.splitlines():
        line = raw.rstrip()

        # Track headings.
        if line.startswith("## ") and not line.startswith("### "):
            top_category = line[3:].strip()
            sub_category = None
            in_skip = top_category in SKIP_CATEGORIES
            continue
        if line.startswith("### "):
            sub_category = line[4:].strip()
            continue
        if line.startswith("# "):
            top_category = None
            sub_category = None
            in_skip = False
            continue

        if in_skip or top_category is None:
            continue

        m = LINE_RE.match(line)
        if not m:
            continue
        name, url, desc = m.group(1).strip(), m.group(2).strip(), (m.group(3) or "").strip()

        # Skip in-page anchor links like `[**⬆ back to top**](#contents)`.
        if url.startswith("#"):
            continue

        category = f"{top_category} / {sub_category}" if sub_category else top_category
        yield category, name, url, desc


def enrich_github(url: str, token: Optional[str]) -> dict:
    m = GITHUB_REPO_RE.match(url)
    if not m:
        return {}
    owner, repo = m.group(1), m.group(2)
    api = f"https://api.github.com/repos/{owner}/{repo}"
    data = http_get_json(api, token)
    if not data:
        return {}
    return {
        "stars": data.get("stargazers_count", ""),
        "last_updated": data.get("pushed_at", "") or data.get("updated_at", ""),
        "archived": "y" if data.get("archived") else "n",
        "api_desc": data.get("description") or "",
    }


def clean_desc(s: str) -> str:
    # Strip surrounding markdown formatting cruft and collapse whitespace.
    s = re.sub(r"\s+", " ", s).strip()
    # Drop trailing period for tidiness, leave inner punctuation alone.
    return s


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--input", default="/tmp/awesome-neovim.md",
                   help="Path to README.md (downloaded if missing)")
    p.add_argument("--output", default="awesome-neovim.csv",
                   help="Output CSV path")
    p.add_argument("--no-enrich", action="store_true",
                   help="Skip GitHub API enrichment (much faster, minimal CSV)")
    p.add_argument("--limit", type=int, default=0,
                   help="Stop after N plugins (debug/testing)")
    args = p.parse_args()

    if not os.path.exists(args.input):
        download_readme(args.input)

    with open(args.input, "r", encoding="utf-8") as f:
        text = f.read()

    token = os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN")
    if not token and not args.no_enrich:
        sys.stderr.write(
            "WARNING: no GITHUB_TOKEN env var set; unauthenticated GitHub API "
            "is limited to 60 requests/hour. Set GITHUB_TOKEN or pass "
            "--no-enrich.\n"
        )

    plugins = list(parse_readme(text))
    # Deduplicate by (category, url) preserving order.
    seen = set()
    unique = []
    for entry in plugins:
        key = (entry[0], entry[2])
        if key in seen:
            continue
        seen.add(key)
        unique.append(entry)

    sys.stderr.write(f"Found {len(unique)} plugin entries.\n")

    if args.limit:
        unique = unique[: args.limit]

    with open(args.output, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow([
            "category", "repo_url", "github_stars", "last_updated",
            "archived", "one_line_desc",
        ])

        for i, (category, name, url, desc) in enumerate(unique, 1):
            stars = ""
            last_updated = ""
            archived = ""
            api_desc = ""
            if not args.no_enrich:
                info = enrich_github(url, token)
                stars = info.get("stars", "")
                last_updated = info.get("last_updated", "")
                archived = info.get("archived", "")
                api_desc = info.get("api_desc", "")

            one_line = clean_desc(desc) or clean_desc(api_desc)
            writer.writerow([category, url, stars, last_updated, archived, one_line])

            if i % 25 == 0:
                sys.stderr.write(f"  processed {i}/{len(unique)}\n")
                f.flush()

    sys.stderr.write(f"Wrote {args.output}\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
