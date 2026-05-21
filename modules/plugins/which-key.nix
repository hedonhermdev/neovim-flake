{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.which-key-nvim
  ];

  vim.lazyPlugins = [
    ''
      {
        "which-key.nvim",
        event = "DeferredUIEnter",
        after = function()
          pcall(function()
            require('which-key').setup({})
          end)
        end,
      }
    ''
  ];
}
