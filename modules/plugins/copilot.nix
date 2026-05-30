{ config, lib, pkgs, ... }:

{
  # Lazy-loaded on InsertEnter (FIXME #22). copilot.vim only provides inline
  # ghost-text suggestions while typing, so there's no reason to source it (and
  # spawn its Node agent) during startup. It has no dependents that need it as a
  # start plugin, so InsertEnter is the right trigger.
  vim.optPlugins = with pkgs.neovimPlugins; [
    copilot-vim
  ];

  # copilot.vim reads these globals when its plugin/ script sources. They are set
  # at startup (well before any InsertEnter), so they are in place by the time
  # lz.n packadds copilot on the first insert. The <C-J> map is an expr mapping
  # whose RHS (copilot#Accept) is only evaluated on keypress, so defining it at
  # startup does not force the autoload to load early.
  vim.luaConfigRC = ''
    -- Keep copilot.vim off <Tab> entirely (FIXME #28): blink.cmp owns <Tab>
    -- (select_next / snippet_forward / fallback) and Neovim's core default maps
    -- <Tab> to vim.snippet.jump. copilot suggestions are accepted with <C-J>.
    --
    -- We do NOT set copilot_assume_mapped: it is unused in this copilot.vim pin
    -- (the plugin only reads copilot_no_tab_map / copilot_no_maps), so setting it
    -- was a no-op that misleadingly implied <Tab> is wired to copilot accept. It
    -- isn't, and shouldn't be — that would fight blink. Dropped to stop lying.
    vim.g.copilot_no_tab_map = true
    vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
      silent = true,
    })
  '';

  vim.lazyPlugins = [
    ''
      {
        "copilot-vim",
        event = "InsertEnter",
      }
    ''
  ];
}
