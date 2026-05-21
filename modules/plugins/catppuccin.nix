{ config, lib, pkgs, ... }:

{
  vim.startPlugins = with pkgs.neovimPlugins; [
    catppuccin
  ];

  vim.luaConfigRC = ''
    vim.g.catppuccin_flavour = "macchiato"
    require('catppuccin').setup()

    vim.cmd [[ colorscheme catppuccin ]]
  '';
}
