local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)


return require('lazy').setup({
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = { {'nvim-lua/plenary.nvim'} }
    },
    {
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            require("rose-pine").setup({})
            vim.cmd('colorscheme rose-pine')
        end,
    },
    {'nvim-treesitter/nvim-treesitter'},
    {'nvim-treesitter/playground'},
    {'theprimeagen/harpoon'},
    {'mbbill/undotree'},
    {'tpope/vim-fugitive'},
    -- LSP suppor
    -- {"williamboman/mason.nvim"},
    -- {"williamboman/mason-lspconfig.nvim"},
    {'neovim/nvim-lspconfig'},             -- Required
    { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} },
    { "folke/neodev.nvim", opts = {} },
    -- Autocompletion
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        lazy = true,

        dependencies = {
            "rafamadriz/friendly-snippets",
            "saadparwaiz1/cmp_luasnip"
        },
        build = "make install_jsregexp"
    },
    {'hrsh7th/nvim-cmp'},         -- Required
    {'hrsh7th/cmp-nvim-lsp'},     -- Required
    {'saadparwaiz1/cmp_luasnip'}, -- Optional

    {
        'nvim-lualine/lualine.nvim',
        dependencies = {'nvim-tree/nvim-web-devicons', opt = true}
    },
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- Optional
        },
        config = function ()
            require("nvim-tree").setup {}
        end
    },
})
