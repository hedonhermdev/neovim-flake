{ config, lib, pkgs, ... }:

{
  # base46 is the theme engine. It hard-requires `nvconfig` (base46/init.lua
  # line 3: `require("nvconfig").base46`), and nvconfig.lua ships inside
  # nvchad-ui — so ui must be on the rtp even for a base46-only spike. We put
  # it on the rtp here; nvchad-ui's overlay `dependencies` (volt/plenary/
  # devicons) come along automatically. The UI itself is NOT activated yet —
  # `require "nvchad"` (statusline/tabufline/nvdash) is wired in Phase 1. Just
  # being on the rtp lets `require "nvconfig"` resolve.
  #
  # nvconfig merges our overrides from `require "chadrc"`; we register that via
  # package.preload below so nothing has to be written onto the read-only rtp.
  vim.startPlugins = with pkgs.neovimPlugins; [
    base46
    nvchad-ui
  ];

  # Strategy 1 (runtime cache): base46.compile() writes highlight bytecode to
  # vim.g.base46_cache via io.open(..., "wb"). The Nix store is read-only, so
  # point the cache at stdpath("data") (writable, regenerable). This also keeps
  # the cache writable for the interactive theme picker (volt) to recompile on
  # the fly.
  #
  # mkOrder 100: matches the slot catppuccin used. Highlight load must precede
  # other modules' highlight definitions (mkOrder 1000), otherwise a later
  # `:colorscheme`/clear would wipe groups base46 just set. This REPLACES
  # catppuccin as the sole theme authority — do not run both.
  vim.luaConfigRC = lib.mkOrder 100 ''
    -- chadrc: user overrides merged over nvchad-ui's nvconfig defaults.
    -- Kept minimal for the Phase 0 spike; expanded in chadrc.lua (Phase 1).
    package.preload["chadrc"] = function()
      return {
        base46 = {
          theme = "onedark",
        },
      }
    end

    vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"

    -- Compiles on first run (writes the cache), then dofiles each cached
    -- highlight file. Guarded so a base46 error can't abort the rest of init.
    pcall(function()
      require("base46").load_all_highlights()
    end)
  '';
}
