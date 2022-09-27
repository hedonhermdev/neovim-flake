{ config, lib, pkgs, ... }:
{
  imports = [
    ./general.nix
    ./indent.nix
    ./fold.nix
    ./split.nix
  ];
}
