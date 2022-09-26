{ config, pkgs, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim;
  wrapLuaConfig = luaConfig: ''
    lua << EOF
    ${luaConfig}
    EOF
  '';
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
      description = "List of plugins to startup";
      default = [];
      type = with types; listOf (nullOr package);
    };

    optPlugins = mkOption {
      description = "List of plugins to optionally load";
      default = [];
      type = with types; listOf package;
    };

    vimAlias = mkOption {
      description = "Enable vim alias";
      type = types.bool;
      default = true;
    };

    viAlias = mkOption {
      description = "Enable vi alias";
      type = types.bool;
      default = true;
    };
  };

  config = {
    vim.configRC = ''
      ${wrapLuaConfig (concatStringsSep "\n" [cfg.luaConfigRC])}
    '';
  };
}
