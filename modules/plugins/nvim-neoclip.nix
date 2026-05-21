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
            -- Make sure telescope is loaded before registering the
            -- extension; lz.n's command stub for :Telescope handles the
            -- packadd.
            vim.cmd("packadd telescope")
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
