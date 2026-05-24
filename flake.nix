{
  description = "hedonhermdev's nvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter/main";
      flake = false;
    };

    treesitter-textobjects = {
      url = "github:nvim-treesitter/nvim-treesitter-textobjects/main";
      flake = false;
    };

    avante = {
      url = "github:yetone/avante.nvim";
      flake = false;
    };

    render-markdown = {
      url = "github:MeanderingProgrammer/render-markdown.nvim";
      flake = false;
    };

    catppuccin = {
      url = "github:catppuccin/nvim";
      flake = false;
    };

    treesitter-context = {
      url = "github:nvim-treesitter/nvim-treesitter-context/b311b30818951d01f7b4bf650521b868b3fece16";
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

    noice = {
      url = "github:folke/noice.nvim";
      flake = false;
    };

    nui = {
      url = "github:MunifTanjim/nui.nvim";
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

    lsp_signature = {
      url = "github:ray-x/lsp_signature.nvim";
      flake = false;
    };

    blink-cmp = {
      url = "github:saghen/blink.cmp";
      flake = false;
    };

    blink-lib = {
      url = "github:saghen/blink.lib";
      flake = false;
    };

    luasnip = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };

    rustaceanvim = {
      url = "github:mrcjkb/rustaceanvim/1d89cf1b7b84862706398a263396b24960d80695";
      flake = false;
    };

    autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };

    outline = {
      url = "github:hedyhli/outline.nvim";
      flake = false;
    };

    vimtex = {
      url = "github:lervag/vimtex";
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

    friendly-snippets = {
      url = "github:rafamadriz/friendly-snippets";
      flake = false;
    };

    scnvim = {
      url = "github:davidgranstrom/scnvim";
      flake = false;
    };

    copilot-vim = {
      url = "github:github/copilot.vim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      supportedSystems = [ "aarch64-darwin" "aarch64-linux" "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
      plugins = [
        { name = "autopairs"; requireCheck = "nvim-autopairs"; }
        { name = "catppuccin"; requireCheck = "catppuccin"; }
        { name = "blink-cmp"; dependencies = [ "luasnip" "blink-lib" ]; requireCheck = "blink.cmp"; }
        { name = "blink-lib"; requireCheck = "blink.lib"; }
        { name = "cokeline"; dependencies = [ "plenary" ]; }
        "devicons"
        "friendly-snippets"
        "fugitive"
        "gitsigns"
        { name = "indent-blankline"; requireCheck = "ibl"; }
        "lazygit"
        { name = "lsp_signature"; dependencies = [ "lspconfig" ]; }
        "lspconfig"
        "lspkind"
        "luasnip"
        "move"
        { name = "noice"; dependencies = [ "nui" ]; }
        "nui"
        "numb"
        { name = "nvim-tree"; requireCheck = "nvim-tree"; }
        { name = "plenary"; requireCheck = "plenary"; }
        { name = "rustaceanvim"; dependencies = [ "lspconfig" "plenary" ]; requireCheck = "rustaceanvim"; }
        "scnvim"
        { name = "outline"; requireCheck = "outline"; }
        { name = "telescope"; dependencies = [ "plenary" ]; }
        { name = "treesitter"; requireCheck = "nvim-treesitter"; }
        { name = "treesitter-textobjects"; dependencies = [ "treesitter" ]; requireCheck = "nvim-treesitter-textobjects"; }
        { name = "treesitter-context"; dependencies = [ "treesitter" ]; }
        "vim-nix"
        "vimtex"
        { name = "avante"; dependencies = [ "plenary" "nui" ]; requireCheck = "avante"; }
        { name = "render-markdown"; dependencies = [ "treesitter" ]; }
        { name = "copilot-vim"; requireCheck = []; }
      ];

    in
    {
      apps = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = { allowUnfree = true; };
            overlays = [ (import ./lib { inherit pkgs inputs plugins; }).buildPluginOverlay ];
          };
          neovimBuilder = (import ./lib { inherit pkgs inputs plugins; }).neovimBuilder;
          nvim = {
            type = "app";
            program = "${neovimBuilder { config = {}; }}/bin/nvim";
          };
        in {
          inherit nvim;
          default = nvim;
        });

      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = { allowUnfree = true; };
            overlays = [ (import ./lib { inherit pkgs inputs plugins; }).buildPluginOverlay ];
          };
          neovimBuilder = (import ./lib { inherit pkgs inputs plugins; }).neovimBuilder;
        in {
          default = pkgs.mkShell {
            buildInputs = [
              (neovimBuilder { config = {}; })
              pkgs.lazygit
              pkgs.tree-sitter
            ];
          };
        });

      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = { allowUnfree = true; };
            overlays = [ (import ./lib { inherit pkgs inputs plugins; }).buildPluginOverlay ];
          };
          neovimBuilder = (import ./lib { inherit pkgs inputs plugins; }).neovimBuilder;
          nvimPacked = neovimBuilder { config = {}; };
        in {
          inherit nvimPacked;
          default = nvimPacked;
        });

      overlays.default = final: prev: {
        nvimPacked = self.packages.${final.system}.nvimPacked;
      };

      nixosModules.default = { config, lib, pkgs, ... }: {
        options.programs.nvimPacked = {
          enable = lib.mkEnableOption "hedonhermdev's neovim configuration";
        };
        config = lib.mkIf config.programs.nvimPacked.enable {
          environment.systemPackages = [
            self.packages.${pkgs.system}.nvimPacked
          ];
        };
      };

      homeManagerModules.default = { config, lib, pkgs, ... }: {
        options.programs.nvimPacked = {
          enable = lib.mkEnableOption "hedonhermdev's neovim configuration";
        };
        config = lib.mkIf config.programs.nvimPacked.enable {
          home.packages = [
            self.packages.${pkgs.system}.nvimPacked
          ];
        };
      };

      formatter = forAllSystems (system:
        (import nixpkgs { inherit system; }).nixpkgs-fmt);
    };
}
