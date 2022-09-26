{
  pkgs,
  inputs,
  plugins,
  ...
}: {
  inherit (pkgs.lib);

  configBuilder = import ./configBuilder.nix {inherit inputs;};

  neovimBuilder = import ./neovimBuilder.nix {inherit pkgs;};

  buildPluginOverlay = import ./buildPlugin.nix {inherit pkgs inputs plugins;};
}

