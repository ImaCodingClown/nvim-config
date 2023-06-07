vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", function()
    local api = require('nvim-tree.api')
    api.tree.open()
end
)

vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>yy", '"+yy')
vim.keymap.set("n", "<leader>Y", '"+Y')

vim.keymap.set("n", "<leader>p", '"+p')
vim.keymap.set("v", "<leader>p", '"+p')
vim.keymap.set("n", "<leader>P", '"+P')

vim.keymap.set("n", "<leader>nv", vim.cmd.NvimTreeToggle)
