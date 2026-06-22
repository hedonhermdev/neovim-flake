{ pkgs, ... }:

{
  vim.startPlugins = with pkgs.neovimPlugins; [
    lspconfig
    lspkind
    lsp_signature
    blink-cmp
    blink-lib
    luasnip
    friendly-snippets
  ];

  vim.optPlugins = with pkgs.neovimPlugins; [
    rustaceanvim
    outline
    autopairs
  ];

  vim.lazy = [
    {
      name = "rustaceanvim";
      ft = [ "rust" ];
    }
    {
      name = "outline";
      cmd = [
        "Outline"
        "OutlineOpen"
        "OutlineClose"
        "OutlineToggle"
      ];
      after = ''
        require('outline').setup()
      '';
    }
    {
      name = "autopairs";
      event = [ "InsertEnter" ];
      after = ''
        require('nvim-autopairs').setup()
      '';
    }
  ];

  vim.luaConfigRC = ''
    vim.diagnostic.config({ virtual_lines = false, virtual_text = false })

    vim.schedule(function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end)

    require('blink.cmp').setup({
      keymap = {
        preset = 'default',
        ['<C-b>']     = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>']     = { 'scroll_documentation_down', 'fallback' },
        ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>']     = { 'hide', 'fallback' },
        ['<CR>']      = { 'accept', 'fallback' },
        ['<Tab>']     = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>']   = { 'select_prev', 'snippet_backward', 'fallback' },
        ['<C-n>']     = { 'select_next', 'snippet_forward', 'fallback' },
        ['<C-p>']   = { 'select_prev', 'snippet_backward', 'fallback' },
      },

      snippets = { preset = 'luasnip' },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        per_filetype = {
          gitcommit = { 'buffer' },
        },
      },

      completion = {
        documentation = { auto_show = true },
        menu = {
          border = 'rounded',
          draw = { treesitter = { 'lsp' } },
        },
      },

      signature = { enabled = false },
    })

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    vim.lsp.config('*', {
      capabilities = capabilities,
    })

    vim.lsp.config('ts_ls', {
      root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
      workspace_required = true,
    })

    vim.lsp.config('denols', {
      root_markers = { "deno.json", "deno.jsonc" },
      workspace_required = true,
    })

    vim.lsp.config('basedpyright', {
      handlers = {
        -- Kill both diagnostic channels so basedpyright never renders diagnostics.
        -- Push channel (server-initiated):
        ["textDocument/publishDiagnostics"] = function() end,
        -- Pull channel (client-requested):
        ["textDocument/diagnostic"] = function() end,
      },
      settings = {
        basedpyright = {
          disableOrganizeImports = true,
        },
      },
    })

    vim.lsp.config('ruff', {})

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
          return
        end
        if client.name == 'ruff' then
          -- Disable hover in favor of basedpyright
          client.server_capabilities.hoverProvider = false
        end
      end,
      desc = 'LSP: Disable hover capability from Ruff',
    })

    vim.lsp.enable({
      "ts_ls",
      "nixd",
      "texlab",
      "clangd",
      "denols",
      "bashls",
      "dockerls",
      "docker_compose_language_service",
      "helm_ls",
      "ruff",
      "ty",
      "svelte",
      "julials",
    })

    vim.g.rustaceanvim = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<C-space>", function() vim.cmd.RustLsp({ "hover", "actions" }) end, { buffer = bufnr })
          vim.keymap.set("n", "<Leader>ca", function() vim.cmd.RustLsp("codeAction") end, { buffer = bufnr })
        end,
      },
    }

    do
      local fenced = vim.g.markdown_fenced_languages or {}
      local seen = {}
      for _, v in ipairs(fenced) do seen[v] = true end
      for _, v in ipairs({ "ts=typescript" }) do
        if not seen[v] then
          table.insert(fenced, v)
          seen[v] = true
        end
      end
      vim.g.markdown_fenced_languages = fenced
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        -- Attach lsp_signature to this buffer (FIXME #25), per its documented
        -- on_attach(cfg, bufnr) API, instead of a one-shot global setup().
        pcall(function() require("lsp_signature").on_attach({}, args.buf) end)
        local bufnr = args.buf
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>xv", function() 
          local c = vim.diagnostic.config() or {}
          local e = not c.virtual_lines
          vim.diagnostic.config({ virtual_lines = e, virtual_text = false })
        end)
      end,
    })
  '';
}
