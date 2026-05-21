{ config, lib, pkgs, ... }:

{
  vim.luaConfigRC = ''
    -- Searching
    vim.opt.incsearch = true -- Start searching on character press
    vim.opt.hlsearch = true -- Highlight matched characters
    vim.opt.ignorecase = true -- Ignore case when searching with lowercase characters
    vim.opt.smartcase = true -- Do not ignore case when searching with mixed characters
  '';
}
