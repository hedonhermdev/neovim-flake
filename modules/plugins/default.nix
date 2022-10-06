{ config, lib, pkgs, ... }:
{
  vim.startPlugins = with pkgs.neovimPlugins; [
    plenary
  ];
  imports = [
    ./treesitter.nix
    ./catppuccin.nix
    # ./indent-blankline.nix
    ./telescope.nix
    # ./bufferline.nix
    ./treesitter-context.nix
  ];
}
