{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.persistence-nvim
  ];

  vim.lazy = [
    {
      name = "persistence.nvim";
      event = [ "DeferredUIEnter" ];
      after = builtins.readFile ./persistence.lua;
    }
  ];
}
