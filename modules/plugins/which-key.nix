{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.neovimPlugins.which-key
  ];

  # Pop-up that shows pending keybindings as you type a prefix. Loaded at
  # DeferredUIEnter (same slot the other UI plugins use). This coexists with
  # NvChad's NvCheatsheet (<leader>ch): which-key is the live on-keypress
  # discovery popup, NvCheatsheet is the static full-grid reference — no
  # keybind clash.
  vim.lazy = [
    {
      name = "which-key";
      event = [ "DeferredUIEnter" ];
      after = ''
        require('which-key').setup({})
      '';
    }
  ];
}
