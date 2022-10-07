{ config, pkgs, lib, ... }: 
with lib;
with builtins;
{
  vim.startPlugins = with pkgs.neovimPlugins; [
    gitsigns
  ];
  vim.luaConfigRC = ''
    require('gitsigns').setup()
  '';
}
