require("snacks").setup({
  -- Dashboard retired in favour of NvChad's nvdash (see chadrc.lua
  -- nvdash.load_on_startup). Terminal retired in favour of NvChad's term
  -- (see nvchad-ui.nix keybind). snacks stays for notifier/input/bigfile/
  -- quickfile.
  dashboard = { enabled = false },
  notifier = { enabled = true },
  input = { enabled = true },
  terminal = { enabled = false },
  bigfile = { enabled = true },
  quickfile = { enabled = true },
})
