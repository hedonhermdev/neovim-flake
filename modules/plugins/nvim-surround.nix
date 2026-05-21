{ config, pkgs, lib, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.nvim-surround
  ];

  vim.lazyPlugins = [
    ''
      {
        "nvim-surround",
        event = "DeferredUIEnter",
        after = function()
          pcall(function()
            require('nvim-surround').setup({})
          end)
        end,
      }
    ''
  ];
}
