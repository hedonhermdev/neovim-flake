require("snacks").setup({
  -- Dashboard retired in favour of NvChad's nvdash (see chadrc.lua
  -- nvdash.load_on_startup). snacks stays for notifier/input/terminal/
  -- bigfile/quickfile.
  dashboard = { enabled = false },
  notifier = { enabled = true },
  input = { enabled = true },
  terminal = { enabled = true },
  bigfile = { enabled = true },
  quickfile = { enabled = true },
})
