{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkEnableOption types;

  # FIXME #19: heavy language toolchains (LSP servers, formatters, linters,
  # interpreters) used to be bundled unconditionally onto nvim's PATH in
  # lib/neovimBuilder.nix, giving a ~7.3 GiB closure. They are now per-language
  # opt-in options. The actual package -> PATH wiring lives in
  # lib/neovimBuilder.nix, which reads `config.vim.languages.<lang>.*`.
  #
  # Default policy ("curated lean default ON"): light, broadly-useful toolchains
  # default to ON (nix, lua, shell, web, markdown); heavy / niche ones default
  # to OFF (python+debugpy, latex, c/c++, docker, rust formatter). Override per
  # build, e.g. `vim.languages.python.enable = true`.
  mkLang = { description, default }: {
    enable = mkOption {
      inherit default;
      type = types.bool;
      description = description;
    };
  };
in {
  options.vim.languages = {
    # --- curated ON by default (light, widely used) ---
    nix = mkLang { description = "Nix toolchain (nixd LSP)."; default = true; };
    lua = mkLang { description = "Lua toolchain (stylua formatter)."; default = true; };
    shell = mkLang { description = "Shell toolchain (bash LSP, shfmt, shellcheck)."; default = true; };
    web = mkLang { description = "Web toolchain (prettier for js/ts/json/yaml/html/css/md)."; default = true; };
    markdown = mkLang { description = "Markdown toolchain (markdownlint-cli)."; default = true; };

    # --- heavy / niche, OFF by default ---
    python = mkLang { description = "Python toolchain (pyright, ruff, python3+debugpy). ~1.7 GiB."; default = false; };
    latex = mkLang { description = "LaTeX toolchain (texlab)."; default = false; };
    c = mkLang { description = "C/C++ toolchain (clang-tools). ~1.4 GiB."; default = false; };
    docker = mkLang { description = "Docker toolchain (dockerfile-language-server, hadolint)."; default = false; };
    rust = mkLang { description = "Rust formatter (rustfmt). rust-analyzer ships via rustaceanvim."; default = false; };
  };
}
