{ config, pkgs, lib, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.nvim-surround
  ];

  vim.lazy = [
    {
      name = "nvim-surround";
      event = [ "DeferredUIEnter" ];
      after = ''
        require('nvim-surround').setup({})
      '';
    }
  ];
}
