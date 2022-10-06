{ config, lib, pkgs, ... }:
{
  imports = [
    ./core
    ./options
    ./plugins
    ./keybindings
  ];
}
