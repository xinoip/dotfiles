return {
    {
        'fredrikaverpil/godoc.nvim',
        version = '*',
        dependencies = {
            { 'folke/snacks.nvim' }, -- optional
            { 'ibhagwan/fzf-lua' }, -- optional
            {
                'nvim-treesitter/nvim-treesitter',
                opts = {
                    ensure_installed = { 'go' },
                },
            },
        },
        cmd = { 'GoDoc' }, -- optional
        opts = {
            picker = {
                type = 'snacks',
            },
        }, -- see further down below for configuration
    },
    {
        'olexsmir/gopher.nvim',
        ft = 'go',
        -- build = function()
        --     vim.cmd.GoInstallDeps()
        -- end,
        ---@type gopher.Config
        opts = {
            gotag = {
                transform = 'camelcase',
            },
        },
    },
}
