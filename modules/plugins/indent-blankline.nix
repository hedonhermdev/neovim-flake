{ config, lib, pkgs, ... }:

{
  vim.optPlugins = with pkgs.neovimPlugins; [
    indent-blankline
  ];

  vim.lazy = [
    {
      name = "indent-blankline";
      event = [ "DeferredUIEnter" ];
      after = ''
        require("ibl").setup({})
      '';
    }
  ];
}
