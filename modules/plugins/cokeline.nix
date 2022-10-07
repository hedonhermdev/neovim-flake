{ config, lib, pkgs, ... }:

with builtins;
with lib;
{
  vim.startPlugins = with pkgs.neovimPlugins; [
    cokeline
  ];
  vim.luaConfigRC = ''
    require('cokeline').setup({
      buffers = {
        filter_valid = function(buffer) return buffer.type ~= 'terminal' end,
      },
    })
  '';
}
