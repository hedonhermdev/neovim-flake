{ config, pkgs, lib, ... }: 
with lib;
with builtins;
{
  vim.startPlugins = with pkgs.neovimPlugins; [
    lazygit
    gitsigns
  ];
  vim.luaConfigRC = ''
    require('gitsigns').setup()
  '';
  vim.nmap = {
    "<leader>gg" = ":LazyGit<CR>";
  };
}
