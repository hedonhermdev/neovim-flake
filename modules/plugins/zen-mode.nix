{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.zen-mode-nvim
  ];

  vim.lazy = [
    {
      name = "zen-mode.nvim";
      cmd = [ "ZenMode" ];
      keys = [ "<leader>zf" ];
      after = ''
        require('zen-mode').setup({})
      '';
    }
  ];

  vim.nmap = {
    "<leader>zf" = ":ZenMode<CR>";
  };
}
