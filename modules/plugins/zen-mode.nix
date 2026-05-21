{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.zen-mode-nvim
  ];

  vim.lazyPlugins = [
    ''
      {
        "zen-mode.nvim",
        cmd = "ZenMode",
        keys = { "<leader>zf" },
        after = function()
          pcall(function()
            require('zen-mode').setup({})
          end)
        end,
      }
    ''
  ];

  vim.nmap = {
    "<leader>zf" = ":ZenMode<CR>";
  };
}
