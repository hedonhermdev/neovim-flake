{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.nvim-bqf
  ];

  vim.lazyPlugins = [
    ''
      {
        "nvim-bqf",
        ft = "qf",
        after = function()
          pcall(function()
            require('bqf').setup({
              auto_enable = true,
              preview = {
                win_height = 12,
                win_vheight = 12,
                delay_syntax = 80,
                border = 'rounded',
              },
            })
          end)
        end,
      }
    ''
  ];
}
