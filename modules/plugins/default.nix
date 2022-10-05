{ config, lib, pkgs, ... }:
{
  imports = [
    ./treesitter.nix
    ./catppuccin.nix
    ./indent-blankline.nix
    ./telescope.nix
    ./bufferline.nix
    ./treesitter-context.nix
  ];
}
