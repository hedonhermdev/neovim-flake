{ config, lib, pkgs, ... }:

let
  inherit (builtins) concatStringsSep;
  specs = config.vim.lazyPlugins;
  specsLua = concatStringsSep ",\n" specs;
in {
  vim.startPlugins = [
    pkgs.vimPlugins.lz-n
  ];

  # Run after every other module's luaConfigRC has been concatenated so the
  # spec list (collected from each plugin module via vim.lazyPlugins) is
  # complete by the time we hand it off to lz.n.
  vim.luaConfigRC = lib.mkAfter ''
    pcall(function()
      require('lz.n').load({
        ${specsLua}
      })
    end)
  '';
}
