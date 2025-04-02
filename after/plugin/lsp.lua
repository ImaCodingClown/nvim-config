local lsp = require('lspconfig')
local lsputil = require("lspconfig/util")

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

local venv_path = os.getenv('VIRTUAL_ENV')
local py_path = nil
-- decide which python executable to use for mypy
if venv_path ~= nil then
py_path = venv_path .. "/bin/python3"
else
py_path = vim.g.python3_host_prog
end

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = {buffer = event.buf}

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

require('lspconfig').tsserver.setup{}

require('lspconfig').lua_ls.setup({
    capabilities = lsp_capabilities,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT'
            },
            diagnostics = {
                globals = {'vim'},
            },
            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                }
            }
        }
    }
})

lsp.pyright.setup {
    settings = {
        python = {
            analysis = {
                -- warnings in factory boy for meta class overide
                typeCheckingMode = "basic"
            }
        }
    }
}

lsp.protols.setup{}

-- lsp["pylsp"].setup {
--     enable = false,
--     capabilities = lsp_capabilities,
--     settings = {
--         cmd = { lsputil.path.join(os.getenv("VIRTUAL_ENV"), "bin/pylsp") },
--         cmd_env = {
--             PATH = lsputil.path.join(".venv", "bin") .. ":" .. vim.env.PATH,
--         },
--         pylsp = {
--             configurationSources = {"flake8", "mypy"},
--             plugins = {
--                 pylsp_mypy = {
--                     enabled = true,
--                     overrides = { "--python-executable", py_path, true },
--                 },
--                 pyflakes = { enabled = false },
--                 jedi = { environment = os.getenv("VIRTUAL_ENV") or "/usr" },
--                 isort = {enabled = true},
--                 ruff = {
--                     enabled = true,
--                     ignore = {
--                         'E501'
--                     }
--                 },
--                 pydocstyle = {
--                     enabled = false,
--                     convention = 'google',
--                     ignore = {
--                         'E501',
--                     }
--                 },
--                 pycodestyle = {
--                     enabled = false,
--                     ignore = {
--                         'E501'
--                     }
--                 },
--             },
--         }
--     },
--     on_new_config = function(new_config, new_root_dir)
--         local py = require("utils.python.lua")
--         py.env(new_root_dir)
--         new_config.settings.pylsp.plugins.jedi.environment = py.get_python_dir(new_root_dir)
--     end
-- }

lsp.rust_analyzer.setup({
    capabilities = lsp_capabilities,
    settings = {
        ["rust_analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enablue = true
            },
        }
    }
})




vim.diagnostic.config({
    virtual_text = true,
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

vim.opt.completeopt = {'menu', 'menuone', 'noselect'}


require('luasnip.loaders.from_vscode')

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
