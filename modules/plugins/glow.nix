{ config, lib, pkgs, ... }:

with lib;
with pkgs;

{
  vim.startPlugins = with pkgs.neovimPlugins; [
    glow
  ];

  vim.luaConfigRC = ''
    require('glow').setup({
      glow_path = "${pkgs.glow}/bin/glow"
    })
  '';
}
