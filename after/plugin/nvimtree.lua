
vim.keymap.set("n", "<leader>nv", vim.cmd.NvimTreeToggle)
vim.keymap.set("n", "<leader>pv", function()
    local api = require('nvim-tree.api')
    api.tree.open()
end
)
