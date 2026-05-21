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

    -- Tab == 2 spaces for .nix, .js, .ts
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "nix",
      callback = function()
        vim.bo.shiftwidth = 2
        vim.bo.softtabstop = 2
        vim.bo.expandtab = true
      end,
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      callback = function()
        vim.bo.shiftwidth = 2
        vim.bo.softtabstop = 2
        vim.bo.expandtab = true
      end,
    })
  '';
}
