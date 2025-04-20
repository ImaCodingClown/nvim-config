
local api = require('nvim-tree.api')
local nvim_tree = require('nvim-tree')
vim.keymap.set("n", "<leader>nv", vim.cmd.NvimTreeToggle)
vim.keymap.set("n", "<leader>pv", function()
    api.tree.open()
end
)


nvim_tree.setup{
    update_focused_file = {
        enable = true
    }
}
