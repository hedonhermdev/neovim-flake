{ config, lib, pkgs, ... }:

{
  vim.optPlugins = with pkgs.neovimPlugins; [
    copilot-vim
  ];

  vim.lazyPlugins = [
    ''
      {
        "copilot-vim",
        event = "InsertEnter",
        cmd = "Copilot",
      }
    ''
  ];

  # copilot.vim reads these on load; set them before the plugin sources.
  vim.luaConfigRC = ''
    -- Disable the default <Tab> mapping so it doesn't fight with completion;
    -- accept suggestions with <C-J> instead.
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
      silent = true,
    })
  '';
}
