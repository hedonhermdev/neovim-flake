{ pkgs, lib, config, ... }:

{
  vim.luaConfigRC = ''
    -- Tab == 4 spaces
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = true
    vim.opt.smarttab = true
    vim.opt.autoindent = true

    -- Tab == 2 spaces for .nix, .js, .ts (FIXME #24). Use a cleared augroup so
    -- re-sourcing $MYVIMRC replaces these autocmds instead of accumulating
    -- duplicates. Both filetypes share the same callback, so they're a single
    -- autocmd with a combined pattern.
    local indent2 = vim.api.nvim_create_augroup("UserIndent2Space", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = indent2,
      pattern = { "nix", "javascript", "typescript", "javascriptreact", "typescriptreact" },
      callback = function()
        vim.bo.shiftwidth = 2
        vim.bo.softtabstop = 2
        vim.bo.expandtab = true
      end,
    })
  '';
}
