{ config, lib, pkgs, ... }:

let
  # Explicit grammar list keeps the closure small (each parser is ~1-3 MB,
  # and `withAllGrammars` pulls in ~100 of them). Add languages as needed.
  grammars = ps: with ps; [
    bash
    c
    cpp
    css
    dockerfile
    go
    html
    javascript
    json
    lua
    markdown
    markdown_inline
    nix
    python
    query
    regex
    rust
    toml
    tsx
    typescript
    vim
    vimdoc
    yaml
    latex
    supercollider
  ];
in
{
  vim.startPlugins = [
    (pkgs.vimPlugins.nvim-treesitter.withPlugins grammars)
  ];

  vim.luaConfigRC = ''
    -- nvim-treesitter `main` branch no longer exposes a setup() entry point.
    -- Drive highlights manually via FileType autocmd; folds via vim.treesitter.foldexpr.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("NvimTreesitterStart", { clear = true }),
      callback = function(args)
        -- Guard by parser availability (FIXME #15): only start treesitter and
        -- set the treesitter indentexpr for filetypes that actually have a
        -- grammar installed. Otherwise `=G`/`==` would invoke
        -- nvim-treesitter.indentexpr() against a missing parser and error.
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if not (lang and vim.treesitter.language.add(lang)) then
          return
        end
        pcall(vim.treesitter.start, args.buf)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    -- Fold ENGINE owned solely by this module (FIXME #23): foldmethod +
    -- foldexpr. Display/behaviour (foldenable, foldlevel, fillchars) is owned by
    -- modules/options/fold.nix, so it is intentionally NOT set here.
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  '';
}
