{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.nvim-neoclip-lua
  ];

  vim.lazyPlugins = [
    ''
      {
        "nvim-neoclip.lua",
        keys = { "<leader>fy" },
        after = function()
          pcall(function()
            require("neoclip").setup({})
            -- Ensure telescope is fully loaded *and* its lz.n `after`
            -- hook (which calls require("telescope").setup{}) has run
            -- before registering the extension. `trigger_load` does
            -- both; a bare `packadd` would skip the setup hook (FIXME #17).
            local lz_ok, lz = pcall(require, "lz.n")
            if lz_ok and lz.trigger_load then
              lz.trigger_load("telescope")
            else
              -- Fallback for the (currently unreachable) case where lz.n is
              -- absent: packadd alone leaves telescope unconfigured, so run
              -- its setup explicitly rather than skipping it.
              vim.cmd("packadd telescope")
              pcall(function() require("telescope").setup({}) end)
            end
            pcall(function()
              require("telescope").load_extension("neoclip")
            end)
          end)
        end,
      }
    ''
  ];

  vim.luaConfigRC = ''
    vim.keymap.set("n", "<leader>fy", "<cmd>Telescope neoclip<CR>", { desc = "Clipboard history" })
  '';
}
