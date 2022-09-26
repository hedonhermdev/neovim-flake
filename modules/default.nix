{ config, lib, pkgs, ... }:

{
  imports = [
    ./core
    ./indent.nix
  ];
}
