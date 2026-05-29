{
  pkgs,
  inputs,
  plugins,
  ...
}: final: prev: let
  # Each entry in `plugins` is either a string (the plugin name) or an attrset
  # of the form:
  #   { name = "blink-cmp"; dependencies = [ "luasnip" ]; requireCheck = "blink.cmp"; }
  #
  # - `dependencies` lists sibling plugins that must be on the runtimepath for
  #   the plugin's Lua `require` calls to resolve during
  #   `neovimRequireCheckHook`. They must also appear elsewhere in `plugins`.
  # - `requireCheck` pins `nvimRequireCheck` to an explicit module name (or
  #   list), bypassing the auto-discovery that mis-handles filenames with
  #   literal dots (e.g. `ibl/config.types.lua`) or optional integration
  #   modules that depend on packages we don't ship.
  normalize = entry:
    if builtins.isString entry then { name = entry; }
    else entry;

  pluginSpecs = map normalize plugins;

  # blink.cmp ships a Rust fuzzy matcher that its Lua loader expects at
  # `<plugin>/target/release/libblink_cmp_fuzzy.{so,dylib}`. We build the
  # crate with rustPlatform and symlink the cdylib into the vim plugin
  # output so the require-check (and runtime) finds it.
  blinkFuzzyLib =
    let
      src = inputs.blink-cmp;
      stdenv = prev.stdenv;
      libExt = if stdenv.hostPlatform.isDarwin then "dylib" else "so";
    in
    prev.rustPlatform.buildRustPackage {
      pname = "blink-cmp-fuzzy";
      version = "master";
      inherit src;
      cargoLock = {
        lockFile = "${src}/Cargo.lock";
        # Allow git dependencies (frizbee etc.) if any appear in the lockfile.
        allowBuiltinFetchGit = true;
      };
      # The workspace contains the library crate; build only it.
      buildAndTestSubdir = ".";
      doCheck = false;
      # blink's build.rs shells out to `git rev-parse HEAD`; that fails in
      # the Nix sandbox. Replace it with a no-op that still emits the
      # version file the runtime loader expects.
      postPatch = ''
        cat > build.rs <<'EOF'
        fn main() {
            std::fs::create_dir_all("target/release").ok();
            std::fs::write("target/release/version", "nix").ok();
        }
        EOF
      '';
      # Install just the cdylib(s) into $out/lib.
      installPhase = ''
        runHook preInstall
        mkdir -p $out/lib
        find target -type f \( -name 'libblink_cmp_fuzzy.so' \
                            -o -name 'libblink_cmp_fuzzy.dylib' \) \
          -exec cp {} $out/lib/ \;
        # `find -exec cp` exits 0 even when it matched nothing, which would
        # leave $out/lib empty and produce a dangling symlink at the consumer
        # (FIXME #3). Assert the cdylib actually exists before we declare success.
        if [ -z "$(find "$out/lib" -name 'libblink_cmp_fuzzy.*' -print -quit)" ]; then
          echo "ERROR: blink fuzzy cdylib not produced (no libblink_cmp_fuzzy.{so,dylib} under target/)" >&2
          exit 1
        fi
        if [ -f target/release/version ]; then
          cp target/release/version $out/lib/version
        fi
        runHook postInstall
      '';
      meta.libExt = libExt;
    };

  buildPlug = spec:
    let
      depNames = spec.dependencies or [];
      requireCheck = spec.requireCheck or null;
      isBlink = spec.name == "blink-cmp";
      libExt = if prev.stdenv.hostPlatform.isDarwin then "dylib" else "so";
    in
    (prev.vimUtils.buildVimPlugin ({
      pname = spec.name;
      version = "master";
      src = builtins.getAttr spec.name inputs;
    } // prev.lib.optionalAttrs (requireCheck != null) {
      nvimRequireCheck = requireCheck;
    } // prev.lib.optionalAttrs isBlink {
      postInstall = ''
        mkdir -p $out/lib
        ln -sf ${blinkFuzzyLib}/lib/libblink_cmp_fuzzy.${libExt} \
          $out/lib/libblink_cmp_fuzzy.${libExt}
      '';
    })).overrideAttrs (old: {
      dependencies = (old.dependencies or [])
        ++ map (n: final.neovimPlugins.${n}) depNames;
    });
in {
  neovimPlugins =
    (builtins.listToAttrs
      (map (spec: {
          inherit (spec) name;
          value = buildPlug spec;
        })
        pluginSpecs))
    # Deduplicated single-source aliases (FIXME #2). These plugins are already
    # pulled onto the runtimepath transitively from nixpkgs (e.g. avante-nvim →
    # plenary.nvim / nui.nvim / nvim-treesitter; diffview/neotest → plenary.nvim).
    # Rather than ALSO building a second copy from a flake input, we point the
    # dependency name at the same nixpkgs derivation the transitive deps use, so
    # exactly one copy lands on the rtp. nvim-treesitter in nixpkgs tracks the
    # `main` branch and exposes `indentexpr()`, matching what treesitter.nix needs.
    // {
      treesitter = prev.vimPlugins.nvim-treesitter;
      plenary = prev.vimPlugins.plenary-nvim;
      nui = prev.vimPlugins.nui-nvim;
    };
}
