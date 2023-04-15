{
  pkgs,
  inputs,
  plugins,
  ...
}: final: prev: let
  inherit (prev.vimUtils) buildVimPluginFrom2Nix;

  treesitterGrammars = prev.tree-sitter.withPlugins (p: [
    p.tree-sitter-c
    p.tree-sitter-nix
    p.tree-sitter-rust
    p.tree-sitter-python
    p.tree-sitter-go
    p.tree-sitter-haskell
    p.tree-sitter-json
    p.tree-sitter-haskell
    p.tree-sitter-toml
    p.tree-sitter-yaml
    p.tree-sitter-lua
    p.tree-sitter-typescript
    p.tree-sitter-javascript
    p.tree-sitter-html
    p.tree-sitter-markdown
    p.tree-sitter-markdown-inline
  ]);

  buildPlug = name:
    buildVimPluginFrom2Nix {
      pname = name;
      version = "master";
      src = builtins.getAttr name inputs;
      postPatch =
        if (name == "treesitter")
        then ''
          rm -r parser
          ln -s ${treesitterGrammars} parser
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
