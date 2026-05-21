{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.codecompanion-nvim
  ];

  vim.lazyPlugins = [
    ''
      {
        "codecompanion.nvim",
        cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
        keys = { "<leader>cc", "<leader>ca", "<leader>ci" },
        after = function()
          pcall(function()
            require('codecompanion').setup({})
          end)
        end,
      }
    ''
  ];

  vim.luaConfigRC = ''
    vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>",
      { silent = true, desc = "CodeCompanion Chat" })
    vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionActions<cr>",
      { silent = true, desc = "CodeCompanion Actions" })
    vim.keymap.set("v", "<leader>ci", "<cmd>CodeCompanion<cr>",
      { silent = true, desc = "CodeCompanion Inline" })
  '';
}
