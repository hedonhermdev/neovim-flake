{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.oil-nvim
  ];

  vim.lazyPlugins = [
    ''
      {
        "oil.nvim",
        cmd = "Oil",
        after = function()
          pcall(function()
            ${builtins.readFile ./oil.lua}
          end)
        end,
      }
    ''
  ];
}
