{ config, lib, pkgs, ... }:

{
  # nvchad-ui is already placed on the runtimepath by base46.nix (base46 needs
  # its `nvconfig` module at mkOrder 100). This module ACTIVATES the UI:
  # `require "nvchad"` wires the statusline, tabufline, the Nvdash/NvCheatsheet
  # commands, and schedules `nvchad.au` (nvdash-on-startup, colorify, lsp
  # signature, MasonInstallAll, the reload autocmd).
  #
  # Activated at DeferredUIEnter — the same slot lualine/cokeline/snacks used,
  # so timing (incl. nvdash's empty-buffer detection) matches the dashboard it
  # replaces. base46 highlights are already compiled by the time this runs.
  #
  # No optPlugins entry here: the plugin dir is a startPlugin (via base46.nix),
  # and lz.n only needs the require call, not a managed load of a pack/opt dir.
  vim.lazy = [
    {
      name = "nvchad-ui";
      event = [ "DeferredUIEnter" ];
      after = ''
        require "nvchad"
      '';
    }
  ];
}
