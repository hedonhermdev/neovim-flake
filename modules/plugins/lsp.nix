{ config, pkgs, lib, ... }:

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

  vim.lazyPlugins = [
    ''
      {
        "rustaceanvim",
        ft = "rust",
      }
    ''
    ''
      {
        "outline",
        cmd = { "Outline", "OutlineOpen", "OutlineClose", "OutlineToggle" },
        after = function()
          pcall(function()
            require('outline').setup()
          end)
        end,
      }
    ''
    ''
      {
        "autopairs",
        event = "InsertEnter",
        after = function()
          pcall(function()
            require('nvim-autopairs').setup()
          end)
        end,
      }
    ''
  ];

  vim.luaConfigRC = ''
    -- Set up blink.cmp (replacement for nvim-cmp).
    local luasnip = require('luasnip')
    -- Defer the friendly-snippets vscode loader off the startup path (FIXME #12):
    -- lazy_load() walks ~500 friendly-snippets files, which delayed first UI
    -- paint when run inline. vim.schedule runs it after the editor has painted
    -- (and long before any completion/snippet expansion needs the snippets).
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

    -- Migrated to the vim.lsp.config / vim.lsp.enable API (Neovim 0.11+).
    -- The old `require('lspconfig').<server>.setup{}` framework is
    -- deprecated and will be removed in nvim-lspconfig v3.0.0.
    -- nvim-lspconfig still ships per-server config files under
    -- `lsp/<server>.lua` on the runtimepath, which vim.lsp.config picks
    -- up automatically; we only override fields we care about here.

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

    -- Pyright: prefer the active virtualenv's interpreter. Use the
    -- unresolved `$VIRTUAL_ENV/bin/python` path so Pyright can find the
    -- venv's `pyvenv.cfg` (resolving the symlink hands it the base
    -- interpreter and Pyright stops seeing the venv's site-packages).
    local function pyright_python_path()
      local venv = os.getenv("VIRTUAL_ENV")
      if venv and venv ~= "" then
        return venv .. "/bin/python"
      end
      return vim.fn.exepath("python3")
    end

    vim.lsp.config('pyright', {
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "openFilesOnly",
          },
        },
      },
      -- The interpreter path is set solely here (FIXME #16): before_init
      -- re-evaluates VIRTUAL_ENV at LSP-init time, so it picks up a venv
      -- activated after config eval. A duplicate static settings entry would be
      -- captured once at startup and could go stale, so it was removed.
      before_init = function(_, config)
        config.settings.python.pythonPath = pyright_python_path()
      end,
    })

    -- Ruff: linting + import sorting + (optional) formatting via LSP.
    -- Disable hover so Pyright owns hover/type info; ruff owns diagnostics.
    vim.lsp.config('ruff', {
      on_attach = function(client, _)
        client.server_capabilities.hoverProvider = false
      end,
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
      "pyright",
      "ruff",
      "svelte",
      "julials",
    })

    vim.g.rustaceanvim = {
      server = {
        -- FIXME #27: no explicit capability table here. rustaceanvim resolves
        -- vim.lsp.config('*') and deep-merges it over the server config, so the
        -- blink.cmp completion support set on '*' above is injected automatically,
        -- and rustaceanvim's own rust-specific defaults are preserved by that merge.
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<C-space>", function() vim.cmd.RustLsp({ "hover", "actions" }) end, { buffer = bufnr })
          vim.keymap.set("n", "<Leader>a", function() vim.cmd.RustLsp("codeAction") end, { buffer = bufnr })
        end,
      },
    }


    -- lsp_signature is attached per-buffer in the LspAttach autocmd below
    -- (FIXME #25), not via a one-shot global setup() at startup. on_attach binds
    -- the signature-help handler to the specific buffer that just got an LSP
    -- client, which is the plugin's documented integration point.

    -- outline.nvim and nvim-autopairs setup moved into their lz.n
    -- after-hooks below; vim.g.rustaceanvim is set here so rustaceanvim
    -- picks it up on its own ft-triggered load.

    -- Append our fenced-language mappings instead of clobbering whatever the
    -- user / runtime already set (FIXME #26). vim.g.* can't be mutated in place,
    -- so read the existing list, extend with any of ours not already present,
    -- and write it back.
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
      end,
    })
  '';
}
