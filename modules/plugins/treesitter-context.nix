{ config, lib, pkgs, ... }:

{
  vim.optPlugins = with pkgs.neovimPlugins; [
    treesitter-context
  ];
  vim.lazyPlugins = [
    ''
      {
        "treesitter-context",
        event = "DeferredUIEnter",
        after = function()
          pcall(function()
            require('treesitter-context').setup({
              enable = true,
              max_lines = 0,
            })
          end)
        end,
      }
    ''
  ];
}
