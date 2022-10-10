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

    repeat = {
      url = "github:tpope/vim-repeat";
      flake = false;
    };

    fugitive = {
      url = "github:tpope/vim-fugitive";
      flake = false;
    };

    lazygit = {
      url = "github:kdheepak/lazygit.nvim";
      flake = false;
    };

    surround = {
      url = "github:tpope/vim-surround";
      flake = false;
    };

    commentary = {
      url = "github:tpope/vim-commentary";
      flake = false;
    };

    noice = {
      url = "github:folke/noice.nvim";
      flake = false;
    };

    notice = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };

    nui = {
      url = "github:rcarriga/nvim-notify";
      flake = false;
    };

    lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };

    lspkind = {
      url = "github:onsails/lspkind-nvim";
      flake = false;
    };

    lspsaga = {
      url = "github:glepnir/lspsaga.nvim";
      flake = false;
    };

    lsp_signature = {
      url = "github:ray-x/lsp_signature.nvim";
      flake = false;
    };

    code-action-menu = {
      url = "github:weilbith/nvim-code-action-menu";
      flake = false;
    };

    cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };

    vsnip = {
      url = "github:hrsh7th/vim-vsnip";
      flake = false;
    };

    cmp-vsnip = {
      url = "github:hrsh7th/cmp-vsnip";
      flake = false;
    };

    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };

    cmp-calc = {
      url = "github:hrsh7th/cmp-calc";
      flake = false;
    };

    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };

    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };

    cmp-treesitter = {
      url = "github:ray-x/cmp-treesitter";
      flake = false;
    };

    rust-tools = {
      url = "github:simrat39/rust-tools.nvim";
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
    supportedSystems = ["aarch64-darwin" "aarch64-linux" "x86_64-linux"];
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
      "lazygit"
      "fugitive"
      "surround"
      "commentary"
      "nui"
      "notice"
      "noice"
      "lspconfig"
      "lspkind"
      "lspsaga"
      "lsp_signature"
      "code-action-menu"
      "cmp"
      "vsnip"
      "cmp-vsnip"
      "cmp-buffer"
      "cmp-calc"
      "cmp-nvim-lsp"
      "cmp-path"
      "cmp-treesitter"
      "rust-tools"
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
      buildInputs = [
        (neovimBuilder (configBuilder {}))
        pkgs.lazygit
      ];
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
