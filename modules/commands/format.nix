{ config, pkgs, lib, ... }:

{
  vim.luaConfigRC = ''
    -- FIXME #9: use conform.format() instead of vim.lsp.buf.format().
    -- vim.lsp.buf.format() blocks on the first format-capable LSP client and
    -- ignores conform's formatter chain; conform handles multi-formatter /
    -- multi-LSP correctly and falls back to the LSP when no formatter matches.
    vim.api.nvim_create_user_command('Format', function(args)
      -- conform is a lazy (opt) plugin whose formatters_by_ft config is applied
      -- by lz.n's `after` hook. A bare `packadd` would load the code but skip
      -- that hook, leaving no formatters configured. Use lz.n's trigger_load so
      -- conform.setup() runs; this is also needed because :Format may fire
      -- before conform's own BufReadPost/BufNewFile trigger.
      pcall(function() require('lz.n').trigger_load('conform.nvim') end)
      local ok, conform = pcall(require, 'conform')
      if not ok then
        vim.lsp.buf.format()
        return
      end
      local range
      if args.range > 0 then
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, math.huge },
        }
      end
      conform.format({ lsp_format = "fallback", range = range })
    end,
    { range = true })
  '';
}
