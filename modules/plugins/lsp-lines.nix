{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.lsp_lines-nvim
  ];

  # Set the initial diagnostic display config at STARTUP (FIXME #29), not inside
  # the DeferredUIEnter hook. lsp_lines.setup() only registers the virtual_lines
  # renderer; it does not need to run before diagnostics first paint. Previously
  # the `virtual_lines = false` seed lived in the deferred `after` hook, so the
  # first file painted with Neovim's defaults and then flipped once the hook
  # fired — a visible flicker. Seeding here means diagnostics render in their
  # final form (virtual_text on, virtual_lines off) from the very first paint.
  vim.luaConfigRC = ''
    vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
  '';

  vim.lazyPlugins = [
    ''
      {
        "lsp_lines.nvim",
        event = "DeferredUIEnter",
        after = function()
          pcall(function()
            require('lsp_lines').setup()

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
