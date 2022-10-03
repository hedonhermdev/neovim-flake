{
  description = "hedonhermdev's nvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    mars-std.url = "github:mars-research/mars-std";

    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };

    onenord = {
      url = "github:rmehri01/onenord.nvim";
      flake = false;
    };

    treesitter-context = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    
    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };

    bufferline = {
      url = "github:akinsho/nvim-bufferline.lua?ref=v1.2.0";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, mars-std, ... }@inputs:
  let
    supportedSystems = ["aarch64-darwin" "x86_64-linux"];
    plugins = [ 
      #...<fill plugins here> 
      "nvim-treesitter"
      "onenord"
      "treesitter-context"
      "telescope"
      "bufferline"
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
      
  }) // {
      overlays.default = final: prev: {
        inherit (self.lib) neovimBuilder configBuilder;
        nvimPacked = self.packages.${final.system}.nvimPacked;
    };
  };
}
