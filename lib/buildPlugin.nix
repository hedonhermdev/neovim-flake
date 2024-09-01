{
  pkgs,
  inputs,
  plugins,
  ...
}: final: prev: let
  builVimPlugin = prev.vimUtils.buildVimPlugin ;

  buildPlug = name:
    prev.vimUtils.buildVimPlugin {
      name = name;
      version = "master";
      src = builtins.getAttr name inputs;
    };
in {
  neovimPlugins =
    builtins.listToAttrs
    (map (name: {
        inherit name;
        value = buildPlug name;
      })
      plugins);
}
