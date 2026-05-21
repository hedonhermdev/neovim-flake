{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.conform-nvim
  ];

  vim.lazyPlugins = [
    ''
      {
        "conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo", "FormatDisable", "FormatEnable", "FormatToggle" },
        keys = { "<leader>cf" },
        after = function()
          pcall(function()
            local conform = require('conform')

            conform.setup({
              formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff_format", "black" },
                rust = { "rustfmt" },
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                json = { "prettier" },
                jsonc = { "prettier" },
                yaml = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                markdown = { "prettier" },
                nix = { "alejandra" },
                sh = { "shfmt" },
                bash = { "shfmt" },
              },
              format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                  return
                end
                return { timeout_ms = 1000, lsp_format = "fallback" }
              end,
            })

            vim.api.nvim_create_user_command("FormatDisable", function(args)
              if args.bang then
                vim.b.disable_autoformat = true
              else
                vim.g.disable_autoformat = true
              end
            end, {
              desc = "Disable autoformat-on-save",
              bang = true,
            })

            vim.api.nvim_create_user_command("FormatEnable", function()
              vim.b.disable_autoformat = false
              vim.g.disable_autoformat = false
            end, {
              desc = "Re-enable autoformat-on-save",
            })

            vim.api.nvim_create_user_command("FormatToggle", function()
              vim.g.disable_autoformat = not vim.g.disable_autoformat
            end, {
              desc = "Toggle autoformat-on-save",
            })

            vim.keymap.set({ "n", "v" }, "<leader>cf", function()
              conform.format({ async = true, lsp_format = "fallback" })
            end, { silent = true, desc = "Format buffer/range" })
          end)
        end,
      }
    ''
  ];
}
