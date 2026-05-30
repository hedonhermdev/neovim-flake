{ config, pkgs, lib, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.lualine-nvim
  ];

  vim.lazyPlugins = [
    ''
      {
        "lualine.nvim",
        event = "DeferredUIEnter",
        after = function()
          pcall(function()
            require('lualine').setup({
              options = {
                theme = 'auto',
                icons_enabled = true,
                globalstatus = true,
                disabled_filetypes = { 'snacks_dashboard', 'NvimTree' },
              },
              sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = { { 'filename', path = 1 } },
                lualine_x = {
                  -- opencode's live status (working/idle, etc). Guarded require
                  -- so lualine (loaded at DeferredUIEnter) doesn't error if the
                  -- opencode module isn't resolvable; returns "" when unavailable.
                  function()
                    local ok, opencode = pcall(require, 'opencode')
                    if not ok then return "" end
                    return opencode.statusline()
                  end,
                  'encoding', 'fileformat', 'filetype',
                },
                lualine_y = { 'progress' },
                lualine_z = { 'location' },
              },
            })
          end)
        end,
      }
    ''
  ];
}
