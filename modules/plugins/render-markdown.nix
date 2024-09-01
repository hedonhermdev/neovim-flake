{ config, pkgs, lib, ... }: 
with lib;
with builtins;
{
  vim.startPlugins = with pkgs.neovimPlugins; [
    render-markdown
  ];
  vim.luaConfigRC = ''
    require('render-markdown').setup({
      file_types = { 'markdown', 'avante' },
    })
  '';
}
