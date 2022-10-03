{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
  cfg = config.vim.telescope;
in {
  vim.startPlugins = with pkgs.neovimPlugins; [
    indent-blankline
  ];

  vim.luaConfigRC = ''
    vim.opt.list = true
    vim.opt.listchars:append "space:⋅"
    vim.opt.listchars:append "eol:↴"

    require("indent_blankline").setup {
        show_end_of_line = true,
        space_char_blankline = " ",
    }
  '';
}
