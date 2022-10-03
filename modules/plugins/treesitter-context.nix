{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
  cfg = config.vim.treesitter-context;
in {
  vim.luaConfigRC = ''
    require'treesitter-context'.setup {
      enable = true,
      throttle = true,
      max_lines = 0
    }
  '';
}
