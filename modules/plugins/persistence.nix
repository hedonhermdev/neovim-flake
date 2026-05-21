{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.persistence-nvim
  ];

  vim.lazyPlugins = [
    ''
      {
        "persistence.nvim",
        event = "DeferredUIEnter",
        after = function()
          pcall(function()
            ${builtins.readFile ./persistence.lua}
          end)
        end,
      }
    ''
  ];
}
