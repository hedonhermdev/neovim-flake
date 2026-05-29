{ config, lib, pkgs, ... }:

let
  cfg = config.vim;
in {
  vim.luaConfigRC = ''
    -- GENERAL OPTIONS

    vim.g.mapleader = ","

    vim.opt.mouse = "a" -- Enable mouse support

    vim.cmd("syntax enable") -- Enable syntax highlighting

    vim.opt.wrap = true -- Wrap long lines
    vim.opt.linebreak = true -- Don't break words while wrapping lines

    vim.opt.encoding = "utf-8" -- Write files in UTF-8 encoding
    vim.opt.fileencoding = "utf-8"

    vim.opt.number = true -- Show line number.
    vim.opt.relativenumber = true -- Show relative line number

    vim.opt.cursorline = true -- Highlight the current line

    vim.opt.showmode = false -- don't need to see -- INSERT --

    -- Enable 24-bit RGB color in the terminal UI
    vim.o.termguicolors = true

    -- Do NOT enable 'exrc' (FIXME #11): it auto-executes any project-local
    -- .nvim.lua / .exrc / .nvimrc on cwd entry, which is arbitrary code
    -- execution from untrusted repos. Left at Neovim's secure default (off).
    -- If you want per-project config, opt in explicitly with trust prompts
    -- (e.g. `:set exrc` guarded, or a vetted exrc plugin), not globally.
    vim.o.exrc = false
  '';
}
