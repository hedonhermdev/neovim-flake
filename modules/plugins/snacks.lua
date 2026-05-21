require("snacks").setup({
  dashboard = {
    enabled = true,
    preset = {
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = " ", key = "g", desc = "Find Text", action = ":Telescope live_grep" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    -- Override default sections to drop the "startup" section, which
    -- requires lazy.nvim's `lazy.stats` module. Plugins are managed via
    -- Nix here, so that module is unavailable and triggers an error on
    -- WinResized.
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      { section = "recent_files", limit = 5, padding = 1 },
      { section = "projects", limit = 3, padding = 1 },
    },
  },
  notifier = { enabled = true },
  input = { enabled = true },
  terminal = { enabled = true },
  bigfile = { enabled = true },
  quickfile = { enabled = true },
})
