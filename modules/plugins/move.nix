{ config, lib, pkgs, ... }:

{
  # vim-move is also listed in default.nix's optPlugins; the lz.n
  # registration here triggers a packadd on the first <A-j/k/h/l> press.
  vim.lazy = [
    {
      name = "move";
      keys = [ "<A-j>" "<A-k>" "<A-h>" "<A-l>" ];
    }
  ];
}
