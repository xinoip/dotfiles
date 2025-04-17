return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        explorer = { enabled = true },
        image = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true, main = { current = true } },
        quickfile = { enabled = true },
        scope = { enabled = true },
        statuscolumn = { enabled = true },
    },
    keys = {
        {
            '<leader>ff',
            function()
                Snacks.picker.resume()
            end,
            desc = 'Resume',
        },
        {
            '<C-p>',
            function()
                Snacks.picker.files {
                    hidden = true,
                }
            end,
            desc = 'Files',
        },
        {
            '<leader>fg',
            function()
                Snacks.picker.grep()
            end,
            desc = 'Grep',
        },
        {
            '<leader>fb',
            function()
                Snacks.picker.buffers()
            end,
            desc = 'Buffers',
        },
        {
            '<leader>fh',
            function()
                Snacks.picker.help()
            end,
            desc = 'Help',
        },
        {
            '<leader>fm',
            function()
                Snacks.picker.man()
            end,
            desc = 'Man Pages',
        },
        {
            '<leader>e',
            function()
                Snacks.explorer()
            end,
            desc = 'File Explorer',
        },
        {
            'gd',
            function()
                Snacks.picker.lsp_definitions()
            end,
            desc = 'Goto Definition',
        },
        {
            'gD',
            function()
                Snacks.picker.lsp_declarations()
            end,
            desc = 'Goto Declaration',
        },
        {
            'gr',
            function()
                Snacks.picker.lsp_references()
            end,
            nowait = true,
            desc = 'Goto References',
        },
        {
            'gI',
            function()
                Snacks.picker.lsp_implementations()
            end,
            desc = 'Goto Implementation',
        },
        {
            '<leader>fo',
            function()
                Snacks.picker.lsp_symbols()
            end,
            desc = 'LSP Symbols',
        },
        {
            '<leader>fO',
            function()
                Snacks.picker.lsp_workspace_symbols()
            end,
            desc = 'LSP Workspace Symbols',
        },
    },
    init = function()
        vim.api.nvim_create_autocmd('User', {
            pattern = 'VeryLazy',
            callback = function()
                -- Create some toggle mappings
                Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
                Snacks.toggle.diagnostics():map '<leader>ud'
            end,
        })
    end,
}
