{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
  cfg = config.vim.telescope;
in {
  vim.startPlugins = with pkgs.neovimPlugins; [
    telescope
  ];
  vim.luaConfigRC = ''
      require("telescope").setup {
        defaults = {
          vimgrep_arguments = {
            "${pkgs.ripgrep}/bin/rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case"
          },
          pickers = {
            find_command = {
              "${pkgs.fd}/bin/fd",
            },
          },
        }
      }
    '';
}
