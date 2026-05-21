{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.nvim-spider
  ];

  vim.lazyPlugins = [
    ''
      {
        "nvim-spider",
        keys = {
          { "w", mode = { "n", "o", "x" } },
          { "e", mode = { "n", "o", "x" } },
          { "b", mode = { "n", "o", "x" } },
        },
        after = function()
          pcall(function()
            ${builtins.readFile ./nvim-spider.lua}
          end)
        end,
      }
    ''
  ];
}
