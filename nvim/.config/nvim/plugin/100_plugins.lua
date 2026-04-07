vim.pack.add({
    -- Dependencies
    "https://github.com/MunifTanjim/nui.nvim",
    "https://github.com/nvim-lua/plenary.nvim",

    -- Theming
    "https://github.com/oskarnurm/koda.nvim",

    -- Core
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/folke/snacks.nvim",
    "https://github.com/nmac427/guess-indent.nvim",
    "https://github.com/j-hui/fidget.nvim",

    -- Control
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/MagicDuck/grug-far.nvim",
    "https://github.com/christoomey/vim-tmux-navigator",
    "https://github.com/folke/flash.nvim",

    -- LSP
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/folke/lazydev.nvim",
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/nvim-flutter/flutter-tools.nvim",

    -- AI
    "https://github.com/supermaven-inc/supermaven-nvim",
})

require("koda").setup({
    colors = {
        bg = "#000000",
    },
})
vim.cmd("colorscheme koda")

require("guess-indent").setup({})

require("flash").setup({
    modes = {
        char = {
            jump_labels = true,
        },
    },
})

Pio.create_keymap("2D Jump", "n", "s", function()
    require("flash").jump()
end)

require("flutter-tools").setup({})

require("fidget").setup({})
