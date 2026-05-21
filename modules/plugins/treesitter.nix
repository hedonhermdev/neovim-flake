{ config, lib, pkgs, ... }:

{
  vim.startPlugins = [
    pkgs.vimPlugins.nvim-treesitter.withAllGrammars
  ];
  vim.luaConfigRC = ''
    -- nvim-treesitter `main` branch no longer exposes a setup() entry point.
    -- Drive highlights manually via FileType autocmd; folds via vim.treesitter.foldexpr.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("NvimTreesitterStart", { clear = true }),
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })

    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt.foldenable = false
  '';
}
