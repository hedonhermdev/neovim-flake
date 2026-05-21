{ config, pkgs, lib, ... }:

{
  vim.luaConfigRC = ''
    -- Splitting
    vim.opt.splitright = true
    vim.opt.splitbelow = true
  '';
}
