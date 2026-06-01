{ config, lib, pkgs, ... }:

{
  vim.optPlugins = with pkgs.neovimPlugins; [
    numb
  ];

  vim.lazy = [
    {
      name = "numb";
      event = [ "DeferredUIEnter" ];
      after = builtins.readFile ./numb.lua;
    }
  ];
}
