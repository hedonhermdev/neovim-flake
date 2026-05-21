{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.nvim-lint
  ];

  vim.lazyPlugins = [
    ''
      {
        "nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        cmd = "LintTrigger",
        after = function()
          pcall(function()
            ${builtins.readFile ./nvim-lint.lua}
          end)
        end,
      }
    ''
  ];
}
