{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.lsp_lines-nvim
  ];

  vim.lazyPlugins = [
    ''
      {
        "lsp_lines.nvim",
        event = "DeferredUIEnter",
        after = function()
          pcall(function()
            require('lsp_lines').setup()

            -- Start with virtual_lines disabled (use default virtual_text); toggle with keymap
            vim.diagnostic.config({ virtual_lines = false })

            vim.keymap.set("n", "<leader>xv", function()
              local cfg = vim.diagnostic.config() or {}
              local enabled = not cfg.virtual_lines
              vim.diagnostic.config({
                virtual_lines = enabled,
                virtual_text = not enabled,
              })
            end, { silent = true, desc = "Toggle lsp_lines (virtual lines diagnostics)" })
          end)
        end,
      }
    ''
  ];
}
