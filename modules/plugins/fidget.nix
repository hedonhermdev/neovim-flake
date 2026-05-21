{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.fidget-nvim
  ];

  vim.lazyPlugins = [
    ''
      {
        "fidget.nvim",
        event = "DeferredUIEnter",
        after = function()
          pcall(function()
            require('fidget').setup({})
          end)
        end,
      }
    ''
  ];
}
