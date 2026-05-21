{ config, lib, pkgs, ... }:

{
  vim.optPlugins = with pkgs.neovimPlugins; [
    indent-blankline
  ];

  vim.lazyPlugins = [
    ''
      {
        "indent-blankline",
        event = "DeferredUIEnter",
        after = function()
          pcall(function()
            require("ibl").setup({})
          end)
        end,
      }
    ''
  ];
}
