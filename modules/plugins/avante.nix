{ config, pkgs, lib, ... }:

{
  vim.startPlugins = [
    pkgs.vimPlugins.avante-nvim
  ];

  vim.luaConfigRC = ''
    -- Avante's anthropic/claude provider reads the API key from this env var.
    -- Only set the local-endpoint dummy when the user hasn't already exported a
    -- real key (FIXME #10) — unconditionally assigning here clobbered real keys.
    if vim.env.ANTHROPIC_API_KEY == nil or vim.env.ANTHROPIC_API_KEY == "" then
      vim.env.ANTHROPIC_API_KEY = "coproxy-dummy-api-key"
    end

    -- Defer avante.setup() off the init path with vim.schedule (FIXME #7).
    -- This runs after init + packloadall, so any start plugins avante touches
    -- are sourced first, and — unlike a VimEnter autocmd — it still fires in
    -- `--headless` sessions. With provider = "claude", setup() only loads the
    -- claude provider (it never requires copilot), so copilot.vim is now lazy
    -- (InsertEnter, FIXME #22) rather than a start plugin.
    vim.schedule(function()
      require('avante').setup({
        provider = "claude",
        providers = {
          claude = {
            endpoint = "http://localhost:8080", -- Pointing to the local coproxy endpoint
            model = "claude-opus-4.7-1m-internal",
            auth_type = "api",
            timeout = 30000,
          },
        },
        windows = {
          position = "left",
        },
      })
    end)
  '';
}
