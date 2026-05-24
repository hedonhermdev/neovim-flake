{ pkgs, lib ? pkgs.lib, ... }:

{ config }:

let
  neovimPlugins = pkgs.neovimPlugins;

  myNeovimUnwrapped = pkgs.neovim-unwrapped;

  vimOptions = lib.evalModules {
    modules = [
      { imports = [ ../modules ]; }
      config
    ];

    specialArgs = { inherit pkgs; };
  };

  vim = vimOptions.config.vim;
in
pkgs.wrapNeovim myNeovimUnwrapped {
  viAlias = vim.viAlias;
  vimAlias = vim.vimAlias;
  extraMakeWrapperArgs = ''--prefix PATH : "${lib.makeBinPath (with pkgs; [
    nixd
    pyright
    clang-tools
    bash-language-server
    dockerfile-language-server
    texlab
    lazygit
    ripgrep
    fd
    stylua
    ruff
    prettier
    rustfmt
    shfmt
    shellcheck
    hadolint
    markdownlint-cli
    (python3.withPackages (ps: [ ps.debugpy ]))
  ])}"'';
  configure = {
    customRC = vim.configRC;

    packages.myVimPackage = with neovimPlugins; {
      start = vim.startPlugins;
      opt = vim.optPlugins;
    };
  };
}
