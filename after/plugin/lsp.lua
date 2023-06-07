local lsp = require('lspconfig')

lsp.pylsp.setup {
    filetypes = {"python"},
    plugins = {
        flake8 = {
            enabled = true,
            ignore = {},
            maxLineLength = 160
        },
        pylsp_mypy = {enabled = true},
        isort = {enabled = true},
        ruff_lsp = {enabled = true},
    },
}

lsp.lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                globals = {'vim'}
            }
        }
    }
}

local cmp = require('cmp')


vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function()
        local opts = {buffer = true}

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function () vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function () vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function () vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function () vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function () vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function () vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function () vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function () vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function () vim.lsp.buf.signature_help() end, opts)
    end,
})

vim.diagnostic.config({
  virtual_text = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
  },
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {border = 'rounded'}
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {border = 'rounded'}
)

---
-- LSP config
---

-- require('mason').setup({})
-- require('mason-lspconfig').setup({})

local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)


---
-- LSP servers
---

-- lspconfig.tsserver.setup({})
-- lspconfig.html.setup({})
-- lspconfig.cssls.setup({})
-- lspconfig.lua_ls.setup({})


---
-- Autocomplete
---
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

require('luasnip.loaders.from_vscode').lazy_load()

local cmp = require('cmp')
local luasnip = require('luasnip')

local select_opts = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp', keyword_length = 1},
    {name = 'buffer', keyword_length = 3},
    {name = 'luasnip', keyword_length = 2},
  },
  window = {
    documentation = cmp.config.window.bordered()
  },
  formatting = {
    fields = {'menu', 'abbr', 'kind'},
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = 'Ω',
        path = '🖫',
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),

    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-y>'] = cmp.mapping.confirm({select = true}),
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    ['<C-f>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, {'i', 's'}),

    ['<C-b>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {'i', 's'}),

    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1

      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, {'i', 's'}),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, {'i', 's'}),
  },
})
