{ config, pkgs, lib }:
let
  cfg = config.vim;
in {
  vim.configRC = ''
    " Splitting
    set splitright
    set splitbelow
  '';
}
