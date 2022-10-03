{ config, lib, pkgs, ... }:

with lib;
with builtins;
let
  cfg = config.vim.onenord;
in {

  vim.startPlugins = with pkgs.vimPlugins; [
    onenord-nvim
  ];

  vim.luaConfigRC = ''
    require('onenord').setup()

    vim.cmd = [[colorscheme onenord]]
  '';
}
