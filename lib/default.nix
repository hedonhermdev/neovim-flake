{
  pkgs,
  inputs,
  plugins,
  ...
}: {
  lib = pkgs.lib;

  neovimBuilder = import ./neovimBuilder.nix {inherit pkgs inputs;};

  buildPluginOverlay = import ./buildPlugin.nix {inherit pkgs inputs plugins;};
}
