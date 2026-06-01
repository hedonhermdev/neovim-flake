{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.nvim-spider
  ];

  vim.lazy = [
    {
      name = "nvim-spider";
      keys = [
        { lhs = "w"; mode = [ "n" "o" "x" ]; }
        { lhs = "e"; mode = [ "n" "o" "x" ]; }
        { lhs = "b"; mode = [ "n" "o" "x" ]; }
      ];
      after = builtins.readFile ./nvim-spider.lua;
    }
  ];
}
