{ config, pkgs, lib, ... }:
{
  vim.optPlugins = with pkgs.neovimPlugins; [
    render-markdown
  ];

  vim.lazy = [
    {
      name = "render-markdown";
      ft = [ "markdown" ];
      after = ''
        require('render-markdown').setup({
          file_types = { 'markdown' },
        })
      '';
    }
  ];
}
