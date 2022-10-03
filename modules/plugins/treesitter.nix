{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
  cfg = config.vim.treesitter;
in {
  vim.startPlugins = with pkgs.neovimPlugins; [
    treesitter
  ];
  vim.luaConfigRC = ''
    require'nvim-treesitter.configs'.setup {
      highlight = {
          enable = true,
      },
      indent = {
          enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
    }
  '';
}
