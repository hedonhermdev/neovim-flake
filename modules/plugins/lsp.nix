{ config, pkgs, lib, ... }:

with lib;
with builtins;

{
  vim.startPlugins = with pkgs.neovimPlugins; [
      lspconfig
      lspkind
      lspsaga
      lsp_signature
      code-action-menu
      cmp
      luasnip
      cmp-luasnip
      cmp-buffer
      cmp-calc
      cmp-nvim-lsp
      cmp-path
      cmp-treesitter
      rust-tools
      symbols-outline
      autopairs
      friendly-snippets
  ];

  vim.luaConfigRC = ''
      -- Set up nvim-cmp.
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
          -- they way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }, {
        { name = 'buffer' },
        { name = 'path' },
        { name = 'calc' },
        { name = 'treesitter' },
      })
    })

    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
      }, {
        { name = 'buffer' },
      })
    })

    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    local lspconfig = require('lspconfig')

    lspconfig.tsserver.setup{
      capabilities = capabilities
    }

    lspconfig.rnix.setup{
      capabilities = capabilities
    }

    lspconfig.texlab.setup{
      capabilities = capabilities
    }

    lspconfig.clangd.setup {
      capabilities = capabilities
    }

    lspconfig.tsserver.setup {
      capabilities = capabilities
    }

    require'lspconfig'.denols.setup{}

    lspconfig.bashls.setup {
      capabilities = capabilities
    }

    lspconfig.dockerls.setup {
      capabilities = capabilities
    }

    lspconfig.docker_compose_language_service.setup{
      capabilities = capabilities
    }

    lspconfig.helm_ls.setup{
      capabilities = capabilities
    }

    lspconfig.pyright.setup {
      capabilities = capabilities
    }

    local rust_tools = require('rust-tools')
    rust_tools.setup({
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<C-space>", rust_tools.hover_actions.hover_actions, { buffer = bufnr })
          vim.keymap.set("n", "<Leader>a", rust_tools.code_action_group.code_action_group, { buffer = bufnr })
        end,
      },
      capabilities = capabilities
    })


    require("lsp_signature").setup()

    require("symbols-outline").setup()

    require("nvim-autopairs").setup()

    require("lspsaga").setup()

    vim.lsp.set_log_level('DEBUG')

    vim.g.markdown_fenced_languages = {
      "ts=typescript"
    }
  '';

  vim.nmap = {
    "<silent><leader>ca" = "<cmd>Lspsaga code_action<CR>";
    "<silent>gd" = "<cmd>Lspsaga peek_definition<CR>";
    "<silent>gD" = "<cmd>lua vim.lsp.buf.definition()<CR>";
    "<silent>gr" = "<cmd>lua vim.lsp.buf.references()<CR>";
    "<silent><leader>cd" = "<cmd>Lspsaga show_line_diagnostics<CR>";
    "<silent>K" = "<cmd>Lspsaga hover_doc<CR>";
  };
}
