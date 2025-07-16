return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local custom_icerberg_dark = require 'lualine.themes.iceberg_dark'
        custom_icerberg_dark.normal.c.bg = '#000000'

        require('lualine').setup {
            options = {
                globalstatus = true,
                theme = custom_icerberg_dark,
            },
        }
    end,
}
