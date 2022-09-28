{
  description = "hedonhermdev's nvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    mars-std.url = "github:mars-research/mars-std";
  };

  outputs = { self, nixpkgs, mars-std, ... }@inputs:
  let
    supportedSystems = ["aarch64-darwin" "x86_64-linux"];
    plugins = [ 
      #...<fill plugins here> 
    ];

  in mars-std.lib.eachSystem supportedSystems (system: let
    pkgs = nixpkgs.legacyPackages.${system};
    lib = import ./lib {inherit pkgs inputs plugins;};

    inherit (lib) buildPluginOverlay neovimBuilder configBuilder;
    in rec {
      apps = rec {
        nvim = {
          type = "app";
          program = [(neovimBuilder (configBuilder {}))];
        };

        default = nvim;
      };

      devShell = pkgs.mkShell {
        buildInputs = [(neovimBuilder (configBuilder {}))];
      };

      packages = rec {
        nvimPacked = neovimBuilder (configBuilder {});

        default = nvimPacked;
      };
      
      overlays.default = final: prev: {
        inherit neovimBuilder;
        nvimPacked = packages.${system}.nvimPacked;
        neovimPlugins = pkgs.neovimPlugins;
    };
  });
}
