{ pkgs, lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim;
in { 
  vim.configRC = ''
    " Tab == 4 spaces
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
    set expandtab
    set smarttab
    set autoindent

    " Tab == 2 spaces for .c, .nix, .js, .ts
    autocmd FileType nix setlocal shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType nix setlocal shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType js setlocal shiftwidth=2 softtabstop=2 expandtab
  '';
}
