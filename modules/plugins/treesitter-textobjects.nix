{ config, lib, pkgs, ... }:

{
  vim.optPlugins = with pkgs.neovimPlugins; [
    treesitter-textobjects
  ];

  vim.lazy = [
    {
      name = "treesitter-textobjects";
      event = [ "BufReadPre" "BufNewFile" ];
      after = builtins.readFile ./treesitter-textobjects.lua;
    }
  ];
}
