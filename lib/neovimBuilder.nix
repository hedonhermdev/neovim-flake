{ pkgs, lib ? pkgs.lib, ... }:

{ config }:

let
  neovimPlugins = pkgs.neovimPlugins;

  myNeovimUnwrapped = pkgs.neovim-unwrapped;

  vimOptions = lib.evalModules {
    modules = [
      { imports = [ ../modules ]; }
      config
    ];

    specialArgs = { inherit pkgs; };
  };

  vim = vimOptions.config.vim;
in
pkgs.wrapNeovim myNeovimUnwrapped {
  viAlias = vim.viAlias;
  vimAlias = vim.vimAlias;
  configure = {
    customRC = vim.configRC;

    packages.myVimPackage = with neovimPlugins; {
      start = builtins.filter (f: f != null) vim.startPlugins;
      opt = vim.optPlugins;
    };
  };
}
