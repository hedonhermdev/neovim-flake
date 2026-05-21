{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.inc-rename-nvim
  ];

  vim.lazyPlugins = [
    ''
      {
        "inc-rename.nvim",
        cmd = "IncRename",
        keys = { "<leader>rn" },
        after = function()
          pcall(function()
            require('inc_rename').setup({})
          end)
        end,
      }
    ''
  ];

  vim.luaConfigRC = ''
    vim.keymap.set("n", "<leader>rn", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true, silent = true, desc = "LSP Rename (inc-rename)" })
  '';
}
