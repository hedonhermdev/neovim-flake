{ config, lib, pkgs, ... }:

with builtins;
with lib;

let
  cfg = config.vim.treesitter;
in {
  vim.startPlugins = with pkgs.neovimPlugins; [
    bufferline
  ];
  vim.luaConfigRC = ''
    require("bufferline").setup {}
  '';
}
