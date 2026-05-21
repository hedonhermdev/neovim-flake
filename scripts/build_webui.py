#!/usr/bin/env python3
"""Build a single self-contained HTML file with the CSV embedded as JSON.

Usage:
  python scripts/build_webui.py            # writes webui.html, opens it
  python scripts/build_webui.py --no-open  # just write the file
"""
from __future__ import annotations
import argparse, csv, json, os, sys, webbrowser
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TEMPLATE = ROOT / "webui" / "index.html"
CSV_PATH = ROOT / "awesome-neovim.csv"
OUT_PATH = ROOT / "webui.html"


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--csv", default=str(CSV_PATH))
    ap.add_argument("--template", default=str(TEMPLATE))
    ap.add_argument("--output", default=str(OUT_PATH))
    ap.add_argument("--no-open", action="store_true")
    args = ap.parse_args()

    if not os.path.exists(args.csv):
        sys.stderr.write(f"CSV not found: {args.csv}\n")
        return 1

    with open(args.csv, newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))

    with open(args.template, "r", encoding="utf-8") as f:
        html = f.read()

    # Inject data as a JSON island and short-circuit the fetch() in main().
    data_script = (
        "<script id=\"plugin-data\" type=\"application/json\">"
        + json.dumps(rows, ensure_ascii=False).replace("</", "<\\/")
        + "</script>"
    )
    html = html.replace("</head>", data_script + "\n</head>")

    # Replace the fetch-based main() with one that reads the embedded JSON.
    needle = "async function main() {"
    inline_main = (
        "async function main() {\n"
        "  const el = document.getElementById('plugin-data');\n"
        "  if (el) {\n"
        "    state.all = JSON.parse(el.textContent);\n"
        "    populateCategories(); bindControls(); applyFilters(); render();\n"
        "    return;\n"
        "  }\n"
    )
    if needle in html:
        html = html.replace(needle, inline_main, 1)
    else:
        sys.stderr.write("Could not find main() in template; aborting.\n")
        return 2

    with open(args.output, "w", encoding="utf-8") as f:
        f.write(html)

    sys.stderr.write(f"Wrote {args.output} ({len(rows)} rows, {os.path.getsize(args.output)//1024} KB)\n")

    if not args.no_open:
        webbrowser.open("file://" + os.path.abspath(args.output))

    return 0


if __name__ == "__main__":
    sys.exit(main())
