{ pkgs, inputs, lib ? pkgs.lib, ... }:

{ config }:

let
  neovimPlugins = pkgs.neovimPlugins;

  myNeovimUnwrapped = pkgs.neovim-unwrapped;

  vimOptions = lib.evalModules {
    modules = [
      { imports = [ ../modules ]; }
      config
    ];

    specialArgs = { inherit pkgs inputs; };
  };

  vim = vimOptions.config.vim;

  langs = vim.languages;

  # Always-on core tools (small, needed by core editor features like telescope
  # pickers and lazygit integration — not language toolchains).
  corePackages = with pkgs; [
    lazygit
    ripgrep
    fd
  ];

  # Per-language toolchain packages, gated by vim.languages.<lang>.enable
  # (FIXME #19). `optionals` drops the whole sublist when a language is off, so
  # disabling them removes the packages from nvim's PATH and from the closure.
  languagePackages = with pkgs;
    lib.optionals langs.nix.enable [ nixd ]
    ++ lib.optionals langs.lua.enable [ stylua ]
    ++ lib.optionals langs.shell.enable [ bash-language-server shfmt shellcheck ]
    ++ lib.optionals langs.web.enable [ prettier ]
    ++ lib.optionals langs.markdown.enable [ markdownlint-cli ]
    ++ lib.optionals langs.python.enable [ pyright ruff (python3.withPackages (ps: [ ps.debugpy ])) ]
    ++ lib.optionals langs.latex.enable [ texlab ]
    ++ lib.optionals langs.c.enable [ clang-tools ]
    ++ lib.optionals langs.docker.enable [ dockerfile-language-server hadolint ]
    ++ lib.optionals langs.rust.enable [ rustfmt ];

  toolchainPackages = corePackages ++ languagePackages;
in
pkgs.wrapNeovim myNeovimUnwrapped {
  viAlias = vim.viAlias;
  vimAlias = vim.vimAlias;
  extraMakeWrapperArgs = ''--prefix PATH : "${lib.makeBinPath toolchainPackages}"'';
  configure = {
    customRC = vim.configRC;

    packages.myVimPackage = with neovimPlugins; {
      start = vim.startPlugins;
      opt = vim.optPlugins;
    };
  };
}
