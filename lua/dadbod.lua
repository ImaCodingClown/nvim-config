local M = {}

local function db_completion()
    require("cmp").setup.buffer { sources = {{ name = "vim-dadbod-completion" }}}
end

function M.setup()
    vim.g.db_ui_save_location = "~/.config/nvim/db_ui"
end

return M
