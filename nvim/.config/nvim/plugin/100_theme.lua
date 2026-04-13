require("koda").setup({
    colors = {
        bg = "#000000",
    },
})
vim.cmd("colorscheme koda")

local auto_theme = require("lualine.themes.auto")
auto_theme.normal.c.bg = "#000000"

require("lualine").setup({
    options = {
        globalstatus = true,
        theme = auto_theme,
    },
})
