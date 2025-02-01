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
    {
        'epwalsh/obsidian.nvim',
        version = '*', -- recommended, use latest release instead of latest commit
        lazy = true,
        ft = 'markdown',
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
        --   -- refer to `:h file-pattern` for more examples
        --   "BufReadPre path/to/my-vault/*.md",
        --   "BufNewFile path/to/my-vault/*.md",
        -- },
        dependencies = {
            -- Required.
            'nvim-lua/plenary.nvim',

            -- see below for full list of optional dependencies 👇
        },
        opts = {
            workspaces = {
                {
                    name = 'main',
                    path = '~/vault',
                },
            },
            ui = {
                enable = false,
            },
            -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
            completion = {
                -- Set to false to disable completion.
                nvim_cmp = true,
                -- Trigger completion at 2 chars.
                min_chars = 2,
            },
            disable_frontmatter = true,
            preferred_link_style = 'markdown',

            -- see below for full list of options 👇
        },
    },
}
