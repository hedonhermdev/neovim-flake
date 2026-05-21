{ config, lib, pkgs, ... }:

{
  vim.optPlugins = with pkgs.neovimPlugins; [
    cokeline
  ];
  vim.lazyPlugins = [
    ''
      {
        "cokeline",
        event = "DeferredUIEnter",
        after = function()
          pcall(function()
            require('cokeline').setup({
              buffers = {
                filter_valid = function(buffer) return buffer.type ~= 'terminal' end,
              },
            })
          end)
        end,
      }
    ''
  ];
}
