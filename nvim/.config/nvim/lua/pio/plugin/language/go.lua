return {
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
}
