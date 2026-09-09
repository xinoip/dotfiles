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
    sections = {
        lualine_x = {
            {
                function()
                    return "Wrap \u{eb80} "
                end,
                cond = function()
                    return vim.bo.filetype ~= "" and vim.wo.wrap
                end,
                color = { fg = "#a6e3a1" },
            },
            {
                function()
                    return "Diagnostics \u{f03a} "
                end,
                cond = function()
                    return vim.bo.filetype ~= "" and not vim.diagnostic.is_enabled()
                end,
                color = { fg = "#f38ba8" },
            },
            {
                function()
                    return "Auto Format \u{f0265} "
                end,
                cond = function()
                    return not vim.g.pio_format
                end,
                color = { fg = "#f38ba8" },
            },
            "encoding",
            "fileformat",
            "filetype",
        },
    },
})
