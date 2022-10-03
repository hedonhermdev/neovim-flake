{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
  cfg = config.vim.treesitter-context;
in {
  vim.startPlugins = with pkgs.neovimPlugins; [
    treesitter-context
  ];
  vim.luaConfigRC = ''
    require'treesitter-context'.setup {
      enable = true,
      throttle = true,
      max_lines = 0
    }
  '';
}
