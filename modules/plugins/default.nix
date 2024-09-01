{ config, lib, pkgs, ... }:
{
  # plugins that don't require extra config go here
  vim.startPlugins = with pkgs.neovimPlugins; [
    devicons
    plenary
    vim-nix
    move
    fugitive
    surround
    commentary
    exrc
    nui
    dressing
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
    ./lsp.nix
    ./alpha.nix
    ./galaxyline.nix
    ./glow.nix
    ./true-zen.nix
    ./scnvim.nix
    ./avante.nix
    ./render-markdown.nix
  ];
}
