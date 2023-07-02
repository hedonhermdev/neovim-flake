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
      vsnip
      cmp-vsnip
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
    local cmp = require'cmp'

    cmp.setup({
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
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
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' }, -- For vsnip users.
      }, {
        { name = 'buffer' },
      })
    })

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

    lspconfig.bashls.setup{
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
