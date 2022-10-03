{ config, lib, pkgs, ... }:

with lib;
with builtins;
let
  cfg = config.vim.onenord;
in {

  vim.startPlugins = with pkgs.neovimPlugins; [
    onenord
  ];

  vim.luaConfigRC = ''
    require('onenord').setup()

    vim.cmd = [[colorscheme onenord]]
  '';
}
