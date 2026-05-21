{ config, pkgs, lib, ... }:
{
  vim.optPlugins = with pkgs.neovimPlugins; [
    render-markdown
  ];

  vim.lazyPlugins = [
    ''
      {
        "render-markdown",
        ft = { "markdown", "Avante" },
        after = function()
          pcall(function()
            require('render-markdown').setup({
              file_types = { 'markdown', 'avante' },
            })
          end)
        end,
      }
    ''
  ];
}
