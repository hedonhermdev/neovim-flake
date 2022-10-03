{ config, lib, pkgs, ... }:
{
  imports = [
    ./treesitter.nix
    ./onenord.nix
  ];
}
