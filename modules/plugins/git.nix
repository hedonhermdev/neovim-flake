{ config, pkgs, lib, ... }:
{
  vim.optPlugins = with pkgs.neovimPlugins; [
    lazygit
    gitsigns
  ];
  vim.lazyPlugins = [
    ''
      {
        "gitsigns",
        event = "DeferredUIEnter",
        after = function()
          pcall(function()
            require('gitsigns').setup()
          end)
        end,
      }
    ''
    ''
      {
        "lazygit",
        cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
        keys = { "<leader>gg" },
      }
    ''
  ];
  vim.nmap = {
    "<leader>gg" = ":LazyGit<CR>";
  };
}
