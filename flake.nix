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

    fugitive = {
      url = "github:tpope/vim-fugitive";
      flake = false;
    };

    lazygit = {
      url = "github:kdheepak/lazygit.nvim";
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

    opencode = {
      url = "github:nickjvandyke/opencode.nvim";
      flake = false;
    };

    which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };

    base46 = {
      url = "github:NvChad/base46/v3.0";
      flake = false;
    };

    nvchad-ui = {
      url = "github:NvChad/ui/v3.0";
      flake = false;
    };

    volt = {
      url = "github:NvChad/volt";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      supportedSystems = [ "aarch64-darwin" "aarch64-linux" "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

      # Per-system scope: import nixpkgs once (with the plugin overlay) and the
      # neovimBuilder bound to it. All the system-keyed outputs below pull
      # `pkgs` / `neovimBuilder` from here instead of re-importing nixpkgs.
      pkgsFor = system: import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        # `pkgs` self-reference is lazy-safe: buildPluginOverlay only consumes
        # the overlay's final/prev, never the top-level pkgs passed here.
        overlays = [ (import ./lib { pkgs = pkgsFor system; inherit inputs plugins; }).buildPluginOverlay ];
      };
      neovimBuilderFor = pkgs: (import ./lib { inherit pkgs inputs plugins; }).neovimBuilder;

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
        "numb"
        { name = "nvim-tree"; requireCheck = "nvim-tree"; }
        { name = "rustaceanvim"; dependencies = [ "lspconfig" "plenary" ]; requireCheck = "rustaceanvim"; }
        "scnvim"
        { name = "outline"; requireCheck = "outline"; }
        { name = "telescope"; dependencies = [ "plenary" ]; }
        # treesitter / plenary / nui are NOT built from flake inputs (FIXME #2):
        # the `neovimPlugins` overlay aliases these names to the nixpkgs
        # derivations (nvim-treesitter / plenary.nvim / nui.nvim) that are
        # already pulled in transitively, so only one copy lands on the rtp.
        { name = "treesitter-textobjects"; dependencies = [ "treesitter" ]; requireCheck = "nvim-treesitter-textobjects"; }
        { name = "treesitter-context"; dependencies = [ "treesitter" ]; }
        "vim-nix"
        "vimtex"
        { name = "which-key"; requireCheck = "which-key"; }
        { name = "render-markdown"; dependencies = [ "treesitter" ]; }
        { name = "copilot-vim"; requireCheck = [ ]; }
        # opencode.nvim's optional integrations (snacks) are loaded via pcall,
        # so pin the require-check to the top-level module to avoid pulling in
        # packages we don't build from flake inputs.
        { name = "opencode"; requireCheck = "opencode"; }

        # NvChad theming + UI stack. base46 compiles its highlight cache to
        # stdpath("data") at runtime (Strategy 1), so no build step here. ui
        # transitively touches mason/cmp integration modules, so pin the
        # require-check to the top-level "nvchad" module (same trap as opencode).
        # volt is needed for the interactive theme picker / nvcheatsheet floats.
        # base46's top-level module (base46/init.lua line 3) does
        # `require("nvconfig")`, but nvconfig ships in nvchad-ui — and base46
        # can't depend on ui (ui already depends on base46 → cycle). An empty
        # requireCheck triggers auto-discovery (which would re-hit init), so
        # pin the check to `base46.colors`: a self-contained leaf module (pure
        # color math, no requires) that still proves the plugin loads. Runtime
        # is covered by pcall(load_all_highlights) in base46.nix.
        { name = "base46"; requireCheck = "base46.colors"; }
        { name = "volt"; requireCheck = "volt"; }
        { name = "nvchad-ui"; dependencies = [ "base46" "volt" "plenary" "devicons" ]; requireCheck = "nvchad"; }
      ];

    in
    {
      apps = forAllSystems (system:
        let
          pkgs = pkgsFor system;
          neovimBuilder = neovimBuilderFor pkgs;
          nvim = {
            type = "app";
            program = "${neovimBuilder { config = {}; }}/bin/nvim";
          };
        in
        {
          inherit nvim;
          default = nvim;
        });

      devShells = forAllSystems (system:
        let
          pkgs = pkgsFor system;
          neovimBuilder = neovimBuilderFor pkgs;
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              (neovimBuilder { config = { }; })
              pkgs.lazygit
              pkgs.tree-sitter
            ];
          };
        });

      packages = forAllSystems (system:
        let
          pkgs = pkgsFor system;
          neovimBuilder = neovimBuilderFor pkgs;
          nvimPacked = neovimBuilder { config = { }; };
          # All language toolchains disabled — the lean core build (FIXME #19).
          # Demonstrates the closure-size win and is useful for headless/CI use.
          nvimMinimal = neovimBuilder {
            config.vim.languages = {
              nix.enable = false;
              lua.enable = false;
              shell.enable = false;
              web.enable = false;
              markdown.enable = false;
              python.enable = false;
              latex.enable = false;
              c.enable = false;
              docker.enable = false;
              rust.enable = false;
            };
          };
        in
        {
          inherit nvimPacked nvimMinimal;
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
