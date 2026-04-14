local koda_opts = {}
local lualine_theme = require("lualine.themes.auto")

if vim.o.background == "dark" then
    koda_opts.colors = {
        bg = "#000000",
    }
    lualine_theme.normal.c.bg = "#000000"
else
    lualine_theme.normal.c.bg = "#ebebeb"
end

require("koda").setup(koda_opts)
vim.cmd("colorscheme koda")

require("lualine").setup({
    options = {
        globalstatus = true,
        theme = lualine_theme,
    },
})
