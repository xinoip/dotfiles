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

    -- Control
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/MagicDuck/grug-far.nvim",
    "https://github.com/christoomey/vim-tmux-navigator",

    -- LSP
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/folke/lazydev.nvim",
    "https://github.com/rafamadriz/friendly-snippets",

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
