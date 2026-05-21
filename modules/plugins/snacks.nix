{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.snacks-nvim
  ];

  vim.lazyPlugins = [
    ''
      {
        "snacks.nvim",
        event = "DeferredUIEnter",
        after = function()
          pcall(function()
            ${builtins.readFile ./snacks.lua}
          end)
        end,
      }
    ''
  ];
}
