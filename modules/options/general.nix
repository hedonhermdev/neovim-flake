{ config, lib, pkgs, ... }:

let
  cfg = config.vim;
in { 
  vim.configRC = ''
    """ GENERAL OPTIONS

    let g:mapleader = ","

    set mouse=a " Enable mouse support

    syntax enable " Enable syntax highlighting

    set wrap " Wrap long lines
    set linebreak " Dont break words while wrapping lines

    set encoding=utf-8 " Write files in UTF-8 encoding
    set fileencoding=utf-8

    set number " Show line number.
    set relativenumber " Show relative line number

    set t_Co=256 " Use all 256 colors

    set cursorline " Highlight the current line

    set noshowmode " don't need to see -- INSERT --
    '';
}
