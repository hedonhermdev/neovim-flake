{ config, pkgs, lib, ... }:

{
  vim.optPlugins = with pkgs.neovimPlugins; [
    avante
  ];

  vim.lazyPlugins = [
    ''
      {
        "avante",
        cmd = { "AvanteAsk", "AvanteToggle", "AvanteChat", "AvanteEdit" },
        keys = { "<leader>aa", "<leader>at" },
        after = function()
          pcall(function()
            require('avante').setup({
              windows = {
                position = "left",
              },
            })
          end)
        end,
      }
    ''
  ];
}
