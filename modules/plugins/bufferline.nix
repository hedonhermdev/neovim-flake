{ config, lib, pkgs, ... }:

with builtins;
with lib;

let
  cfg = config.vim.treesitter;
in {
  vim.luaConfigRC = ''
    require("bufferline").setup {}
  '';
}
