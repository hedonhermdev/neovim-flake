{ config, lib, pkgs, ... }:

let
  cfg = config.vim;
in {
  vim.configRC = ''
    " Searching
    set incsearch " Start searching on character press
    set hlsearch " Highlight matched characters
    set ignorecase " Ignore case when searching with lowercase characters
    set smartcase " Do not ignore case when searching with mixed characters
  '';
}
