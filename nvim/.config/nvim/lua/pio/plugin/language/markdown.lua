return {
    { enabled = false, 'bullets-vim/bullets.vim' },
    {
        enabled = false,
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
            -- add options here
            -- or leave it empty to use the default settings
        },
        keys = {
            -- suggested keymap
            { '<leader>p', '<cmd>PasteImage<cr>', desc = 'Paste image from system clipboard' },
        },
    },
    {
        'OXY2DEV/markview.nvim',
        lazy = false, -- Recommended
        -- ft = "markdown" -- If you decide to lazy-load anyway

        dependencies = {
            -- You will not need this if you installed the
            -- parsers manually
            -- Or if the parsers are in your $RUNTIMEPATH
            'nvim-treesitter/nvim-treesitter',

            'nvim-tree/nvim-web-devicons',
        },
    },
}
