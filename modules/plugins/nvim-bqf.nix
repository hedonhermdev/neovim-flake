{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.nvim-bqf
  ];

  vim.lazy = [
    {
      name = "nvim-bqf";
      ft = [ "qf" ];
      after = ''
        require('bqf').setup({
          auto_enable = true,
          preview = {
            win_height = 12,
            win_vheight = 12,
            delay_syntax = 80,
            border = 'rounded',
          },
        })
      '';
    }
  ];
}
