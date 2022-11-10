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
  ];

  vim.luaConfigRC = ''
    local cmp = require("cmp")
    local lspkind = require("lspkind");

     local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local feedkey = function(key, mode)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
    end

    cmp.setup({
      snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          end
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({select = true}),
        ["<Up>"] = cmp.mapping.select_prev_item(),
        ["<Down>"] = cmp.mapping.select_next_item(),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif vim.fn["vsnip#available"](1) == 1 then
              feedkey("<Plug>(vsnip-expand-or-jump)", "")
          elseif has_words_before() then
              cmp.complete()
            else
              fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.fn["vsnip#jumpable"](-1) == 1 then
            feedkey("<Plug>(vsnip-jump-prev)", "")
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources(
        {
          {name = "nvim_lsp"},
          {name = "vsnip"} -- For vsnip users.
        },
        {
          {name = "buffer"},
          {name = "calc"},
          {name = "path"},
          {name = "treesitter"}
        }
      ),
      formatting = {
        format = function(entry, vim_item)
          if vim.tbl_contains({"path"}, entry.source.name) then
            local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
            if icon then
              vim_item.kind = icon
              vim_item.kind_hl_group = hl_group
              return vim_item
            end
          end
          return lspkind.cmp_format({with_text = false})(entry, vim_item)
        end
      }
    })

    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )

    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

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

    require("lspsaga").init_lsp_saga()
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
