{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.flash-nvim
  ];

  vim.lazy = [
    {
      name = "flash.nvim";
      keys = [
        { lhs = "s"; mode = [ "n" "x" "o" ]; }
        { lhs = "S"; mode = [ "n" "x" "o" ]; }
        { lhs = "r"; mode = [ "o" ]; }
        { lhs = "R"; mode = [ "x" "o" ]; }
        { lhs = "<C-s>"; mode = [ "c" ]; }
      ];
      after = builtins.readFile ./flash.lua;
    }
  ];
}
