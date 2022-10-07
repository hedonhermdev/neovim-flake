{ config, pkgs, lib, ... }:

{
  vim.startPlugins = with pkgs.neovimPlugins; [
    noice
    notice
    nui
  ];

  vim.luaConfigRC = ''
    require("noice").setup()
  '';
}
