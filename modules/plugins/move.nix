{ config, lib, pkgs, ... }:

with lib;
with builtins;
{
  vim.startPlugins = with pkgs.neovimPlugins; [
    move
  ];
}
