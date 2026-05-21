{ config, lib, pkgs, ... }:

{
  vim.optPlugins = with pkgs.neovimPlugins; [
    treesitter-textobjects
  ];

  vim.lazyPlugins = [
    ''
      {
        "treesitter-textobjects",
        event = { "BufReadPre", "BufNewFile" },
        after = function()
          pcall(function()
            ${builtins.readFile ./treesitter-textobjects.lua}
          end)
        end,
      }
    ''
  ];
}
