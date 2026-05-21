{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.neotest
    pkgs.vimPlugins.neotest-python
    pkgs.vimPlugins.neotest-rust
  ];

  vim.lazyPlugins = [
    ''
      {
        "neotest",
        cmd = { "Neotest" },
        keys = { "<leader>tt", "<leader>tf", "<leader>tA", "<leader>td", "<leader>ts", "<leader>to", "<leader>tO", "<leader>tx" },
        after = function()
          pcall(function()
            ${builtins.readFile ./neotest.lua}
          end)
        end,
      }
    ''
  ];
}
