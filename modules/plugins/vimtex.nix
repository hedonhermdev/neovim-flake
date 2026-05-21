{ config, lib, pkgs, ... }:

{
  vim.optPlugins = with pkgs.neovimPlugins; [
    vimtex
  ];

  vim.lazyPlugins = [
    ''
      {
        "vimtex",
        ft = { "tex", "latex", "plaintex" },
      }
    ''
  ];

  # Set early — vimtex reads this on load.
  vim.luaConfigRC = ''
    vim.g.vimtex_view_method = "zathura"
  '';
}
