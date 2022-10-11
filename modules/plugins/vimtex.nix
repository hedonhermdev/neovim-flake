{ config, lib, pkgs, ... }:

with lib;
with builtins;

{
  vim.startPlugins = with pkgs.neovimPlugins; [
    vimtex
  ];

  vim.configRC = ''
    let g:vimtex_view_method = '${pkgs.zathura}'
  '';
}
