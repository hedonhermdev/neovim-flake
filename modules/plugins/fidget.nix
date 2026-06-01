{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.fidget-nvim
  ];

  vim.lazy = [
    {
      name = "fidget.nvim";
      event = [ "DeferredUIEnter" ];
      after = ''
        require('fidget').setup({})
      '';
    }
  ];
}
