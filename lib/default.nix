{
  pkgs,
  inputs,
  plugins,
  ...
}: {
  lib = pkgs.lib;

  neovimBuilder = import ./neovimBuilder.nix {inherit pkgs;};

  buildPluginOverlay = import ./buildPlugin.nix {inherit pkgs inputs plugins;};
}
