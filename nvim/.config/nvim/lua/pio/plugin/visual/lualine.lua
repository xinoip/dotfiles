return {
    "nvim-lualine/lualine.nvim",
    config = function()
        local auto_theme = require("lualine.themes.auto")
        auto_theme.normal.c.bg = "#000000"

        require("lualine").setup({
            options = {
                globalstatus = true,
                theme = auto_theme,
            },
        })
    end,
}
