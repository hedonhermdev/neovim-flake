{ config, pkgs, lib, ... }:
{
  vim.optPlugins = with pkgs.neovimPlugins; [
    render-markdown
  ];

  vim.lazyPlugins = [
    ''
      {
        "render-markdown",
        ft = { "markdown" },
        after = function()
          pcall(function()
            require('render-markdown').setup({
              file_types = { 'markdown' },
            })
          end)
        end,
      }
    ''
  ];
}
