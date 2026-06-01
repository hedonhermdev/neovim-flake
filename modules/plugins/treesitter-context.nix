{ config, lib, pkgs, ... }:

{
  vim.optPlugins = with pkgs.neovimPlugins; [
    treesitter-context
  ];
  vim.lazy = [
    {
      name = "treesitter-context";
      event = [ "DeferredUIEnter" ];
      after = ''
        require('treesitter-context').setup({
          enable = true,
          max_lines = 0,
        })
      '';
    }
  ];
}
