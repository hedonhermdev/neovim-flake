-- lz.n lazy-loading spec.
--
-- Lists every plugin together with the trigger that should cause it to
-- be `:packadd`ed by lz.n. This file is data only; it does not call
-- `require('lz.n').load` itself. The migration tasks in TODO.md wire it
-- up once plugins have been moved from `start` to `opt`.
--
-- Triggers follow lazy.nvim's spec syntax (subset that lz.n supports):
--   event = "<autocmd>"  | { "<autocmd>", ... }
--   ft    = "<filetype>" | { "<filetype>", ... }
--   cmd   = "<Command>"  | { "<Command>", ... }
--   keys  = "<lhs>"      | { "<lhs>", ... }
--
-- Plugins that must be available before the first redraw (theme,
-- treesitter parsers used at startup, plenary, devicons, nui, blink.cmp core)
-- are intentionally absent — they belong in `start`, not in this spec.

return {
  -- ── UI / quality of life ──────────────────────────────────────────────
  { "which-key.nvim",        event = "VeryLazy" },
  { "fidget.nvim",           event = "VeryLazy" },
  { "lualine.nvim",          event = "VeryLazy" },
  { "gitsigns.nvim",         event = "VeryLazy" },
  { "indent-blankline.nvim", event = "VeryLazy" },
  { "nvim-cokeline",         event = "VeryLazy" },
  { "nvim-treesitter-context", event = "VeryLazy" },
  { "numb.nvim",             event = "VeryLazy" },
  { "snacks.nvim",           event = "VeryLazy" },
  { "nvim-surround",         event = "VeryLazy" },
  { "lsp_lines.nvim",        event = "VeryLazy" },
  { "persistence.nvim",      event = "VeryLazy" },

  -- ── LSP / diagnostics ─────────────────────────────────────────────────
  { "nvim-lspconfig",          event = { "BufReadPre", "BufNewFile" } },
  { "trouble.nvim",            cmd  = { "Trouble", "TroubleToggle" } },
  { "inc-rename.nvim",         cmd  = "IncRename" },

  -- ── Treesitter ────────────────────────────────────────────────────────
  { "nvim-treesitter",              event = { "BufReadPre", "BufNewFile" } },
  { "nvim-treesitter-textobjects",  event = { "BufReadPre", "BufNewFile" } },

  -- ── Filetype-specific ─────────────────────────────────────────────────
  { "rustaceanvim",        ft = "rust" },
  { "vimtex",              ft = { "tex", "latex", "plaintex" } },
  { "render-markdown.nvim", ft = "markdown" },
  { "scnvim",              ft = "supercollider" },

  -- ── Format / lint ─────────────────────────────────────────────────────
  { "conform.nvim", event = { "BufWritePre" }, cmd = { "ConformInfo" } },
  { "nvim-lint",    event = { "BufReadPre", "BufNewFile" } },

  -- ── Editing power ─────────────────────────────────────────────────────
  { "flash.nvim",       keys = { "s", "S", "r", "R" } },
  { "nvim-spider",      keys = { "w", "e", "b", "ge" } },
  { "nvim-neoclip.lua", event = "VeryLazy" },
  { "nvim-move",        keys = { "<A-j>", "<A-k>", "<A-h>", "<A-l>" } },

  -- ── File explorer / pickers ───────────────────────────────────────────
  { "nvim-tree.lua",    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeOpen" } },
  { "telescope.nvim",   cmd = "Telescope" },
  { "oil.nvim",         cmd = "Oil" },

  -- ── Git ───────────────────────────────────────────────────────────────
  { "neogit",        cmd = "Neogit" },
  { "diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewToggleFiles" } },
  { "vim-fugitive",  cmd = { "G", "Git" } },

  -- ── Debug / test / quickfix ───────────────────────────────────────────
  { "nvim-dap",              keys = { "<leader>db", "<leader>dc", "<leader>di", "<leader>do", "<leader>dO" } },
  { "nvim-dap-ui",           keys = { "<leader>du" } },
  { "nvim-dap-virtual-text", event = "VeryLazy" },
  { "neotest",               cmd  = { "Neotest" } },
  { "nvim-bqf",              ft   = "qf" },

  -- ── Zen / focus modes ─────────────────────────────────────────────────
  { "zen-mode.nvim", cmd = "ZenMode" },

  -- ── AI ────────────────────────────────────────────────────────────────
  { "avante.nvim",        keys = { "<leader>aa", "<leader>at" }, cmd = { "AvanteAsk", "AvanteToggle" } },
  { "codecompanion.nvim", keys = { "<leader>cc" },               cmd = { "CodeCompanion", "CodeCompanionChat" } },

  -- ── Completion stack ──────────────────────────────────────────────────
  { "blink.cmp",        event = "InsertEnter" },
  { "luasnip",          event = "InsertEnter" },
  { "nvim-autopairs",   event = "InsertEnter" },
}
