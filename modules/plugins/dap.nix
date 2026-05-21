{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.nvim-dap
    pkgs.vimPlugins.nvim-dap-ui
    pkgs.vimPlugins.nvim-dap-virtual-text
    pkgs.vimPlugins.nvim-nio
    pkgs.vimPlugins.nvim-dap-python
  ];

  vim.lazyPlugins = [
    ''
      {
        "nvim-dap",
        keys = { "<leader>db", "<leader>dB", "<leader>dc", "<leader>di", "<leader>do", "<leader>dO", "<leader>dr", "<leader>dl", "<leader>dt", "<leader>du" },
        after = function()
          pcall(function()
            ${builtins.readFile ./dap.lua}
          end)
        end,
      }
    ''
  ];
}
