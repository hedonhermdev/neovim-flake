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
    require("ibl").setup (
      {
        
      }
    )
  '';
}
