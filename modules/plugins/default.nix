{ config, lib, pkgs, ... }:
{
  imports = [
    ./treesitter.nix
    ./onenord.nix
    ./indent-blankline.nix
    ./telescope.nix
    ./bufferline.nix
    ./treesitter-context.nix
  ];
}
