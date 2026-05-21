{ config, lib, pkgs, ... }:

{
  vim.luaConfigRC = ''
    vim.opt.foldenable = false
    vim.opt.foldlevel = 99
    vim.opt.fillchars = { fold = " " }
    vim.opt.foldmethod = "expr"
  '';
}
