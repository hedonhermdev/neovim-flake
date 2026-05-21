{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.neogit
  ];

  vim.lazyPlugins = [
    ''
      {
        "neogit",
        cmd = "Neogit",
        keys = { "<leader>gn" },
        after = function()
          pcall(function()
            require('neogit').setup({})
          end)
        end,
      }
    ''
  ];

  vim.luaConfigRC = ''
    vim.keymap.set("n", "<leader>gn", "<cmd>Neogit<cr>",
      { silent = true, desc = "Neogit" })
  '';
}
