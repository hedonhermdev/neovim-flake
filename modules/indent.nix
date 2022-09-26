{ pkgs, lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim;
in { 
  vim.configRC = ''
    set et ts=2 sw=2
  '';
}
