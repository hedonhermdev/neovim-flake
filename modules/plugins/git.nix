{ config, pkgs, lib, ... }:
{
  vim.optPlugins = with pkgs.neovimPlugins; [
    lazygit
    gitsigns
  ];
  vim.lazy = [
    {
      name = "gitsigns";
      event = [ "DeferredUIEnter" ];
      after = ''
        require('gitsigns').setup()
      '';
    }
    {
      name = "lazygit";
      cmd = [ "LazyGit" "LazyGitConfig" "LazyGitCurrentFile" "LazyGitFilter" "LazyGitFilterCurrentFile" ];
      keys = [ "<leader>gg" ];
    }
  ];
  vim.nmap = {
    "<leader>gg" = ":LazyGit<CR>";
  };
}
