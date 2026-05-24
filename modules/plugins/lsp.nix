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
    require("luasnip.loaders.from_vscode").lazy_load()

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
          pythonPath = pyright_python_path(),
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "openFilesOnly",
          },
        },
      },
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
        capabilities = capabilities,
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<C-space>", function() vim.cmd.RustLsp({ "hover", "actions" }) end, { buffer = bufnr })
          vim.keymap.set("n", "<Leader>a", function() vim.cmd.RustLsp("codeAction") end, { buffer = bufnr })
        end,
      },
    }


    require("lsp_signature").setup()

    -- outline.nvim and nvim-autopairs setup moved into their lz.n
    -- after-hooks below; vim.g.rustaceanvim is set here so rustaceanvim
    -- picks it up on its own ft-triggered load.

    vim.g.markdown_fenced_languages = {
      "ts=typescript"
    }

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
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
