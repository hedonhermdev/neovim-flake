{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
  cfg = config.vim.treesitter;
in {
  vim.startPlugins = with pkgs.neovimPlugins; [
    true-zen
  ];
  vim.luaConfigRC = ''
    require('true-zen').setup {}
  '';

  vim.nmap = {
    "<leader>zn" = ":TZNarrow<CR>";
    "<leader>zf" = ":TZFocus<CR>";
    "<leader>zm" = ":TZMinimalist<CR>";
    "<leader>za" = ":TZAtaraxis<CR>";
  };
}
