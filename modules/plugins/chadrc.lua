-- chadrc: our overrides, deep-merged over nvchad-ui's nvconfig defaults
-- (see nvchad-ui/lua/nvconfig.lua). Registered via package.preload["chadrc"]
-- in base46.nix so nothing is written onto the read-only store rtp.
--
-- Only fields we deliberately diverge from the defaults on are set here; the
-- rest fall through to nvconfig.
return {
	base46 = {
		theme = "solarized_light",
		-- Themes cycled by the theme picker / toggle. base46's cache is writable
		-- (Strategy 1, stdpath data), so switching recompiles on the fly.
		-- Matches the pre-migration setup (catppuccin, macchiato). base46 ships a
		-- single dark `catppuccin` variant (no per-flavour split) plus a light
		-- `catppuccin-latte`.
		theme_toggle = { "solarized_light", "solarized_dark" },
	},

	ui = {
		statusline = {
			enabled = true,
			theme = "default", -- default/vscode/vscode_colored/minimal
			separator_style = "default",

			-- Re-add opencode's live status (working/idle, etc) to the statusline.
			-- This lived in the retired lualine config (lualine_x); nvchad's
			-- statusline has no knowledge of it, so we register it as a custom
			-- module and splice it into the module order. Guarded require so the
			-- statusline can't error if the opencode module isn't resolvable;
			-- returns "" when unavailable (and we drop the segment entirely so
			-- there's no empty highlight box).
			modules = {
				opencode = function()
					local ok, opencode = pcall(require, "opencode")
					if not ok then
						return ""
					end
					local s = opencode.statusline()
					if s == nil or s == "" then
						return ""
					end
					return "%#St_Lsp# " .. s .. " "
				end,
			},
			-- Default order is
			--   { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "cursor" }
			-- Insert opencode on the right, just before the lsp segment (matching
			-- its old right-aligned position next to encoding/filetype in lualine).
			order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "opencode", "lsp", "cwd", "cursor" },
		},
		tabufline = {
			enabled = true,
			lazyload = true,
		},
		-- cmp styling is owned by blink + lspkind in this config; leave nvchad's
		-- cmp module at defaults (harmless, not activated by our blink setup).
		colorify = {
			enabled = false,
		},
	},

	nvdash = {
		-- Replaces the snacks dashboard: open nvdash when nvim starts on an empty
		-- buffer or a directory.
		load_on_startup = true,

		-- Override the default buttons to DROP nvconfig's footer button, which
		-- calls `require("lazy").stats()` for a plugin-count line. We're
		-- Nix-managed — lazy.nvim isn't present — so that footer throws inside
		-- nvchad.au and aborts the rest of au (colorify, etc). Same trap snacks'
		-- dashboard "startup" section hit. Keep the useful actions; the Themes
		-- button uses volt (present).
		buttons = {
			{ txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
			{ txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
			{ txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
			{ txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
			{ txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },
			{ txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
		},
	},

	term = {
		startinsert = true,
		base46_colors = true,
		winopts = { number = false, relativenumber = false },
		sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
		float = {
			relative = "editor",
			row = 0.3,
			col = 0.25,
			width = 0.5,
			height = 0.4,
			border = "single",
		},
	},

	-- colorify (hex/lsp color preview) has no equivalent in the current config —
	-- enabled by default in nvconfig, kept on as a free win.

	-- We are Nix-managed: Mason is not used. `mason.pkgs = {}` keeps
	-- MasonInstallAll a no-op; the command still exists but installs nothing.
	mason = { pkgs = {}, skip = {} },
}
