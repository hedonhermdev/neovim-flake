{ config, lib, pkgs, ... }:

let
  cfg = config.vim;
in {
  vim.configRC = ''
    set nofoldenable
    set foldlevel=99
    set fillchars=fold:\
    set foldtext=CustomFoldText()
    setlocal foldmethod=expr
  '';

}
