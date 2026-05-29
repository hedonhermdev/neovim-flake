{ config, lib, pkgs, ... }:

{
  # Fold DISPLAY / BEHAVIOUR is owned here; the fold ENGINE (foldmethod +
  # foldexpr) is owned by modules/plugins/treesitter.nix (FIXME #23). Keeping
  # the two concerns in separate, non-overlapping files means neither setting is
  # written twice and load order between the modules no longer matters.
  vim.luaConfigRC = ''
    vim.opt.foldenable = false
    vim.opt.foldlevel = 99
    -- Use :append rather than `= { fold = " " }` so we only override the `fold`
    -- entry and preserve any other fillchars (eob/diff/vert/...) set by Neovim
    -- defaults or other plugins, instead of clobbering the whole table.
    vim.opt.fillchars:append({ fold = " " })
  '';
}
