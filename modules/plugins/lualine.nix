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
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
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
