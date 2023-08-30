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
    vim.opt.runtimepath:append("~/.nvim_treesitter/")
    require'nvim-treesitter.configs'.setup {
      parser_install_dir = "~/.nvim_treesitter/",
      ensure_installed = "all",
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
