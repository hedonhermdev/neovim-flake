{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.flash-nvim
  ];

  vim.lazyPlugins = [
    ''
      {
        "flash.nvim",
        keys = {
          { "s", mode = { "n", "x", "o" } },
          { "S", mode = { "n", "x", "o" } },
          { "r", mode = "o" },
          { "R", mode = { "x", "o" } },
          { "<C-s>", mode = "c" },
        },
        after = function()
          pcall(function()
            ${builtins.readFile ./flash.lua}
          end)
        end,
      }
    ''
  ];
}
