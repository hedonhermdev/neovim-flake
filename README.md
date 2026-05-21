# neovim-flake

hedonhermdev's personal Neovim configuration, packaged as a Nix flake. The flake
produces a self-contained `nvim` wrapped with all plugins, language servers,
and CLI tools it needs — no `:Lazy sync`, no `npm install`, no system packages
required at runtime.

## Quick start

### Run without installing

```sh
nix run github:hedonhermdev/neovim-flake
```

This builds the wrapped neovim and launches it. The first build is slow
(downloads nixpkgs + plugin sources); subsequent runs are cached.

### Drop into a shell with `nvim` on `$PATH`

```sh
nix shell github:hedonhermdev/neovim-flake
nvim
```

Useful when you want to try the config alongside an existing system neovim
without overwriting it.

### Build the package

```sh
nix build github:hedonhermdev/neovim-flake
./result/bin/nvim
```

The `default` package and the `nvimPacked` package are the same derivation.

### Local development

Clone and iterate:

```sh
git clone https://github.com/hedonhermdev/neovim-flake
cd neovim-flake
nix build
./result/bin/nvim
```

After any change, the standard verification step is:

```sh
nix build && ./result/bin/nvim --headless -c 'qa'
```

Both must exit 0 with no Lua errors.

To format the Nix sources:

```sh
nix fmt
```

## Including this flake in your system

### NixOS

```nix
# flake.nix
{
  inputs.nvim-flake.url = "github:hedonhermdev/neovim-flake";

  outputs = { self, nixpkgs, nvim-flake, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nvim-flake.nixosModules.default
        { programs.nvimPacked.enable = true; }
      ];
    };
  };
}
```

### home-manager

```nix
# home.nix (inside a flake using home-manager)
{
  imports = [ inputs.nvim-flake.homeManagerModules.default ];
  programs.nvimPacked.enable = true;
}
```

### As an overlay

```nix
nixpkgs.overlays = [ inputs.nvim-flake.overlays.default ];
# now `pkgs.nvimPacked` is available
environment.systemPackages = [ pkgs.nvimPacked ];
```

## Override patterns

The flake exposes a `neovimBuilder` function (under `lib`) that accepts a
`config` attrset. The simplest override is to pass your own configuration
when consuming the flake locally:

```nix
let
  builder = (import ./lib { inherit pkgs inputs plugins; }).neovimBuilder;
in
  builder { config = { /* extend here */ }; }
```

To override a plugin to a different revision, override the corresponding
flake input:

```nix
inputs.nvim-flake = {
  url = "github:hedonhermdev/neovim-flake";
  inputs.telescope.url = "github:nvim-telescope/telescope.nvim/some-other-rev";
};
```

To swap the `nixpkgs` channel (e.g. pin to a release branch):

```nix
inputs.nvim-flake = {
  url = "github:hedonhermdev/neovim-flake";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

## Layout

- `flake.nix` — inputs, plugin list, outputs (`apps`, `packages`, `devShells`,
  `nixosModules`, `homeManagerModules`, `overlays`, `formatter`).
- `lib/` — `neovimBuilder`, `buildPluginOverlay`, and supporting helpers.
- `modules/` — Lua/Nix modules wired into the builder. Subdirectories:
  - `core/` — option plumbing and the init.lua assembly.
  - `options/` — vim options (indent, fold, general).
  - `plugins/` — per-plugin setup.
  - `keybindings/` — keymaps.
- `scripts/` — helper scripts.
- `TODO.md` — refactor task list (run top-to-bottom).

## Outputs reference

| Output | What it is |
| --- | --- |
| `apps.<system>.default` / `.nvim` | `nix run` target |
| `packages.<system>.default` / `.nvimPacked` | The wrapped neovim derivation |
| `devShells.<system>.default` | Shell with `nvim`, `lazygit`, `tree-sitter` |
| `nixosModules.default` | `programs.nvimPacked.enable` for NixOS |
| `homeManagerModules.default` | Same option for home-manager |
| `overlays.default` | Adds `nvimPacked` to `pkgs` |
| `formatter.<system>` | `nixpkgs-fmt`, used by `nix fmt` |

Supported systems: `x86_64-linux`, `aarch64-linux`, `aarch64-darwin`.
