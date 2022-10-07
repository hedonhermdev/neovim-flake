{ config, lib, pkgs, ... }:
{
  imports = [
    ./general.nix
    ./plugins.nix
  ];
}
