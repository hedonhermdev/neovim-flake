{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.snacks-nvim
  ];

  vim.lazy = [
    {
      name = "snacks.nvim";
      event = [ "DeferredUIEnter" ];
      after = builtins.readFile ./snacks.lua;
    }
  ];
}
