{ config, lib, pkgs, ... }:

{
  vim.optPlugins = with pkgs.neovimPlugins; [
    numb
  ];

  vim.lazyPlugins = [
    ''
      {
        "numb",
        event = "DeferredUIEnter",
        after = function()
          pcall(function()
            ${builtins.readFile ./numb.lua}
          end)
        end,
      }
    ''
  ];
}
