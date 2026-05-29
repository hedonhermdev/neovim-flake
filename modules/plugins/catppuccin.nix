{ config, lib, pkgs, ... }:

{
  vim.startPlugins = with pkgs.neovimPlugins; [
    catppuccin
  ];

  # Explicit load ordering (FIXME #14): pin the colorscheme setup with
  # lib.mkOrder to a low priority so it runs BEFORE other modules'
  # normal-priority (mkOrder 1000) luaConfigRC blocks. `:colorscheme` clears
  # all highlight groups, so it must apply before plugins define their own
  # highlights — otherwise those would be wiped. This also makes the order
  # deterministic instead of relying on default attribute-merge priority
  # (which had no guarantee relative to other ordered blocks like lz-n's mkAfter).
  vim.luaConfigRC = lib.mkOrder 100 ''
    vim.g.catppuccin_flavour = "macchiato"
    require('catppuccin').setup()

    vim.cmd [[ colorscheme catppuccin ]]
  '';
}
