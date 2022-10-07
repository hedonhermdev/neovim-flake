{ config, lib, pkgs, ... }:
{
  # plugins that don't require extra config go here
  vim.startPlugins = with pkgs.neovimPlugins; [
    devicons
    plenary
    vim-nix
    move
  ];
  imports = [
    ./treesitter.nix
    ./catppuccin.nix
    ./indent-blankline.nix
    ./telescope.nix
    ./cokeline.nix
    ./treesitter-context.nix
    ./nvim-tree.nix
    ./git.nix
    ./numb.nix
  ];
}
