{
  pkgs,
  inputs,
  plugins,
  ...
}: final: prev: let
  inherit (prev.vimUtils) buildVimPluginFrom2Nix;

  treesitterGrammars = prev.tree-sitter.withPlugins (p: [

  ]);

  buildPlug = name:
    buildVimPluginFrom2Nix {
      pname = name;
      version = "master";
      src = builtins.getAttr name inputs;
      postPatch =
        if (name == "nvim-treesitter")
        then ''
          rm -r parser
          ln -s ${treesitterGrammars} parser
          mkdir queries/hare
          ln -s ${pkgs.tree-sitter-hare}/queries/* queries/hare
        ''
        else "";
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
