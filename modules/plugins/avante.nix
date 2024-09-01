{ config, pkgs, lib, ... }:

with lib;
with buitlins;

{
  vim.startPlugins = with pkgs.neovimPlugins; [
    avante
  ];

  vim.luaConfigRC = ''
    local avante = require('avante')

    avante.setup({
      windows = {
        position = "left"
      }
    })
  '';
}
