{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.diffview-nvim
  ];

  vim.lazyPlugins = [
    ''
      {
        "diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewRefresh" },
        keys = { "<leader>gd", "<leader>gD", "<leader>gh" },
        after = function()
          pcall(function()
            require('diffview').setup({})
          end)
        end,
      }
    ''
  ];

  vim.luaConfigRC = ''
    vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>",
      { silent = true, desc = "Diffview open" })
    vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewClose<cr>",
      { silent = true, desc = "Diffview close" })
    vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>",
      { silent = true, desc = "Diffview file history" })
  '';
}
