{
  description = "hedonhermdev's nvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    mars-std.url = "github:mars-research/mars-std";

    treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };

    catppuccin = {
      url = "github:catppuccin/nvim";
      flake = false;
    };

    treesitter-context = {
      url = "github:lewis6991/nvim-treesitter-context";
      flake = false;
    };
    
    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };

    cokeline = {
      url = "github:noib3/nvim-cokeline";
      flake = false;
    };

    nvim-tree = {
      url = "github:kyazdani42/nvim-tree.lua";
      flake = false;
    };

    indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };

    vim-nix = {
      url = "github:LnL7/vim-nix";
      flake = false;
    };

    gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };

    numb = {
      url = "github:nacro90/numb.nvim";
      flake = false;
    };

    move = {
      url = "github:matze/vim-move";
      flake = false;
    };
    
    plenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    devicons = {
      url = "github:kyazdani42/nvim-web-devicons";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, mars-std, ... }@inputs:
  let
    supportedSystems = ["aarch64-darwin" "x86_64-linux"];
    plugins = [ 
      #...<fill plugins here> 
      "treesitter"
      "catppuccin"
      "treesitter-context"
      "telescope"
      "cokeline"
      "nvim-tree"
      "indent-blankline"
      "plenary"
      "devicons"
      "vim-nix"
      "numb"
      "move"
      "gitsigns"
    ];

  in mars-std.lib.eachSystem supportedSystems (system:
    let
      lib = import ./lib {inherit pkgs inputs plugins;};

      inherit (lib) buildPluginOverlay neovimBuilder configBuilder;
      
      pkgs = import nixpkgs {
        inherit system;

        config = { allowUnfree = true; };

        overlays = [
            buildPluginOverlay
        ];
      };


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
        inherit neovimBuilder configBuilder;
        neovimPlugins = pkgs.neovimPlugins;
        nvimPacked = neovimBuilder (configBuilder {});

        default = nvimPacked;
      };
      
  }) // { overlays.default = final: prev: {
        inherit (self.lib) neovimBuilder configBuilder;
        nvimPacked = self.packages.${final.system}.nvimPacked;
    };
  };
}
