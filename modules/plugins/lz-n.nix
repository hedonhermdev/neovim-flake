{ config, lib, pkgs, ... }:

let
  inherit (builtins) concatStringsSep isString length head;
  inherit (lib) optional filter concatMapStringsSep;

  luaStr = s: "\"" + lib.escape [ "\\" "\"" ] s + "\"";

  # [] -> null (field omitted); ["a"] -> "a"; ["a" "b"] -> { "a", "b" }
  luaStrList = xs:
    if xs == [] then null
    else if length xs == 1 then luaStr (head xs)
    else "{ " + concatMapStringsSep ", " luaStr xs + " }";

  renderKey = k:
    if isString k then luaStr k
    else "{ " + concatStringsSep ", " (
      [ (luaStr k.lhs) ]
      ++ optional (k.rhs != null) k.rhs
      ++ optional (k.mode != []) "mode = ${luaStrList k.mode}"
      ++ optional (k.desc != null) "desc = ${luaStr k.desc}"
      ++ optional (k.ft != []) "ft = ${luaStrList k.ft}"
    ) + " }";

  renderKeys = ks:
    if ks == [] then null
    else "{ " + concatMapStringsSep ", " renderKey ks + " }";

  luaFn = body: "function()\n${body}\n      end";
  luaFnSafe = body: "function()\n        pcall(function()\n${body}\n        end)\n      end";

  field = n: v: if v == null then null else "${n} = ${v}";
  luaBool = b: if b then "true" else "false";

  renderSpec = s:
    let
      enabledLua =
        if s.enabled == null then null
        else if s.enabled == true || s.enabled == false then luaBool s.enabled
        else s.enabled; # raw lua string
      lines = filter (x: x != null) [
        (luaStr s.name) # positional [1]
        (field "enabled" enabledLua)
        (field "priority" (if s.priority == null then null else toString s.priority))
        (field "cmd" (luaStrList s.cmd))
        (field "ft" (luaStrList s.ft))
        (field "event" (luaStrList s.event))
        (field "colorscheme" (luaStrList s.colorscheme))
        (field "keys" (renderKeys s.keys))
        (field "beforeAll" (if s.beforeAll == null then null else luaFn s.beforeAll))
        (field "before" (if s.before == null then null else luaFn s.before))
        (field "load" (if s.load == null then null else luaFn s.load))
        (field "after" (if s.after == null then null
                        else if s.safeAfter then luaFnSafe s.after else luaFn s.after))
        s.extraLua # raw, already "k = v"
      ];
    in "{\n        " + concatStringsSep ",\n        " lines + ",\n      }";

  rendered = map renderSpec config.vim.lazy;
  specsLua = concatStringsSep ",\n" (rendered ++ config.vim.lazyPlugins);
in {
  vim.startPlugins = [
    pkgs.vimPlugins.lz-n
  ];

  # Run after every other module's luaConfigRC has been concatenated so the
  # spec list (collected from each plugin module via vim.lazyPlugins) is
  # complete by the time we hand it off to lz.n.
  vim.luaConfigRC = lib.mkAfter ''
    pcall(function()
      require('lz.n').load({
        ${specsLua}
      })
    end)
  '';
}
