{ config, pkgs, lib, ... }:

let
  inherit (lib) mkOption types filterAttrs mapAttrsToList;
  inherit (builtins) concatStringsSep;
  cfg = config.vim;
  wrapLuaConfig = luaConfig: ''
    lua << EOF
    ${luaConfig}
    EOF
  '';
  mkMappingOption = it:
    mkOption ({
      default = { };
      type = with types; attrsOf (nullOr str);
    } // it);
in {
  options.vim = {
    configRC = mkOption {
      description = "vimrc contents";
      type = types.lines;
      default = "";
    };

    luaConfigRC = mkOption {
      description = "vim lua config";
      type = types.lines;
      default = "";
    };

    startPlugins = mkOption {
      description = "List of plugins to load on startup";
      default = [];
      type = with types; listOf package;
    };

    optPlugins = mkOption {
      description = "List of plugins to optionally load";
      default = [];
      type = with types; listOf package;
    };

    lazyPlugins = mkOption {
      description = ''
        List of lz.n plugin spec entries (each a Lua table literal as a
        string). lz-n.nix wraps them in `require('lz.n').load({ ... })` after
        all other config has been concatenated.

        This is the raw escape hatch; prefer the structured `vim.lazy` option
        below. Both are merged together by lz-n.nix.
      '';
      default = [];
      type = with types; listOf str;
    };

    lazy = mkOption {
      description = ''
        Structured lz.n plugin specs. Each entry is rendered to a Lua table
        literal by lz-n.nix and handed to `require('lz.n').load`. Use this in
        preference to the raw `lazyPlugins` strings; fall back to `lazyPlugins`
        (or the `extraLua` field) only for spec shapes this option can't model.
      '';
      default = [];
      type = with types; listOf (submodule ({ ... }: {
        options = {
          name = mkOption {
            type = str;
            description = "Plugin name (dir under pack/*/opt). Positional [1] in the lz.n spec.";
          };
          enabled = mkOption {
            type = nullOr (either bool str);
            default = null;
            description = "bool, or raw Lua (e.g. a function/expression).";
          };
          priority = mkOption {
            type = nullOr int;
            default = null;
          };
          cmd = mkOption {
            type = listOf str;
            default = [];
          };
          ft = mkOption {
            type = listOf str;
            default = [];
          };
          event = mkOption {
            type = listOf str;
            default = [];
          };
          colorscheme = mkOption {
            type = listOf str;
            default = [];
          };
          keys = mkOption {
            default = [];
            description = "lz.n key triggers: bare strings, or structured { lhs, mode, rhs, desc, ft } entries.";
            type = listOf (either str (submodule {
              options = {
                lhs = mkOption { type = str; };
                mode = mkOption { type = listOf str; default = []; };
                rhs = mkOption {
                  type = nullOr str;
                  default = null;
                  description = "Raw Lua/string rhs; omit for trigger-only keys.";
                };
                desc = mkOption { type = nullOr str; default = null; };
                ft = mkOption { type = listOf str; default = []; };
              };
            }));
          };
          beforeAll = mkOption {
            type = nullOr lines;
            default = null;
            description = "Lua body wrapped as function() ... end.";
          };
          before = mkOption {
            type = nullOr lines;
            default = null;
          };
          load = mkOption {
            type = nullOr lines;
            default = null;
          };
          after = mkOption {
            type = nullOr lines;
            default = null;
          };
          safeAfter = mkOption {
            type = bool;
            default = true;
            description = "Wrap the after body in pcall(function() ... end) — matches existing behavior.";
          };
          extraLua = mkOption {
            type = nullOr lines;
            default = null;
            description = "Raw escape hatch: verbatim `key = value` table field(s), comma-joined into the spec.";
          };
        };
      }));
    };

    vimAlias = mkOption {
      description = "Enable vim alias";
      type = types.bool;
      default = true;
    };

    viAlias = mkOption {
      description = "Enable vi alias";
      type = types.bool;
      default = false;
    };

    nnoremap =
      mkMappingOption { description = "Defines 'Normal mode' mappings"; };

    inoremap = mkMappingOption {
      description = "Defines 'Insert and Replace mode' mappings";
    };

    vnoremap = mkMappingOption {
      description = "Defines 'Visual and Select mode' mappings";
    };

    xnoremap =
      mkMappingOption { description = "Defines 'Visual mode' mappings"; };

    snoremap =
      mkMappingOption { description = "Defines 'Select mode' mappings"; };

    cnoremap =
      mkMappingOption { description = "Defines 'Command-line mode' mappings"; };

    onoremap = mkMappingOption {
      description = "Defines 'Operator pending mode' mappings";
    };

    tnoremap =
      mkMappingOption { description = "Defines 'Terminal mode' mappings"; };

    nmap = mkMappingOption { description = "Defines 'Normal mode' mappings"; };

    imap = mkMappingOption {
      description = "Defines 'Insert and Replace mode' mappings";
    };

    vmap = mkMappingOption {
      description = "Defines 'Visual and Select mode' mappings";
    };

    xmap = mkMappingOption { description = "Defines 'Visual mode' mappings"; };

    smap = mkMappingOption { description = "Defines 'Select mode' mappings"; };

    cmap =
      mkMappingOption { description = "Defines 'Command-line mode' mappings"; };

    omap = mkMappingOption {
      description = "Defines 'Operator pending mode' mappings";
    };

    tmap =
      mkMappingOption { description = "Defines 'Terminal mode' mappings"; };
  };
  config = let
    filterNonNull = mappings: filterAttrs (name: value: value != null) mappings;
    # Emit lua vim.keymap.set calls. `remap` controls remap=true/false.
    # silent=true by default so `:Cmd<CR>`-style mappings don't echo the
    # command on the cmdline every time they fire (FIXME #8).
    mapLuaBinding = mode: remap: mappings:
      mapAttrsToList (lhs: rhs:
        ''vim.keymap.set("${mode}", "${lhs}", "${lib.escape [ "\"" "\\" ] rhs}", { remap = ${if remap then "true" else "false"}, silent = true })''
      ) (filterNonNull mappings);

    nmap = mapLuaBinding "n" true config.vim.nmap;
    imap = mapLuaBinding "i" true config.vim.imap;
    vmap = mapLuaBinding "v" true config.vim.vmap;
    xmap = mapLuaBinding "x" true config.vim.xmap;
    smap = mapLuaBinding "s" true config.vim.smap;
    cmap = mapLuaBinding "c" true config.vim.cmap;
    omap = mapLuaBinding "o" true config.vim.omap;
    tmap = mapLuaBinding "t" true config.vim.tmap;

    nnoremap = mapLuaBinding "n" false config.vim.nnoremap;
    inoremap = mapLuaBinding "i" false config.vim.inoremap;
    vnoremap = mapLuaBinding "v" false config.vim.vnoremap;
    xnoremap = mapLuaBinding "x" false config.vim.xnoremap;
    snoremap = mapLuaBinding "s" false config.vim.snoremap;
    cnoremap = mapLuaBinding "c" false config.vim.cnoremap;
    onoremap = mapLuaBinding "o" false config.vim.onoremap;
    tnoremap = mapLuaBinding "t" false config.vim.tnoremap;

    allKeymaps = concatStringsSep "\n" (
      nmap ++ imap ++ vmap ++ xmap ++ smap ++ cmap ++ omap ++ tmap ++
      nnoremap ++ inoremap ++ vnoremap ++ xnoremap ++ snoremap ++ cnoremap ++ onoremap ++ tnoremap
    );
  in {
    vim.configRC = wrapLuaConfig ''
      ${cfg.luaConfigRC}

      ${allKeymaps}
    '';
  };
}
