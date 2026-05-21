{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.trouble-nvim
  ];

  vim.lazyPlugins = [
    ''
      {
        "trouble.nvim",
        cmd = { "Trouble", "TroubleToggle", "TroubleClose", "TroubleRefresh" },
        keys = { "<leader>xx", "<leader>xX", "<leader>xs", "<leader>xl", "<leader>xL", "<leader>xq" },
        after = function()
          pcall(function()
            require('trouble').setup({})
          end)
        end,
      }
    ''
  ];

  vim.luaConfigRC = ''
    vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",
      { silent = true, desc = "Diagnostics (Trouble)" })
    vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      { silent = true, desc = "Buffer Diagnostics (Trouble)" })
    vim.keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>",
      { silent = true, desc = "Symbols (Trouble)" })
    vim.keymap.set("n", "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      { silent = true, desc = "LSP Definitions / references (Trouble)" })
    vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>",
      { silent = true, desc = "Location List (Trouble)" })
    vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>",
      { silent = true, desc = "Quickfix List (Trouble)" })
  '';
}
