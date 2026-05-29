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
      '';
      default = [];
      type = with types; listOf str;
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
