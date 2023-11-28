local function configure_lsp()
    local lsp_zero = require('lsp-zero')

    lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({ buffer = bufnr })
    end)

    local cmp = require('cmp')
    local cmp_action = require('lsp-zero').cmp_action()

    cmp.setup({
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        preselect = 'item',
        completion = {
            completeopt = 'menu,menuone,noinsert'
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-f>'] = cmp_action.luasnip_jump_forward(),
            ['<C-b>'] = cmp_action.luasnip_jump_backward(),
            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            ['<C-d>'] = cmp.mapping.scroll_docs(4),
            ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
            ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
            ['<C-y>'] = cmp.mapping.confirm({ select = true }),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<Tab>'] = cmp_action.tab_complete(),
            ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
        })
    })

    require('mason').setup({})
    require('mason-lspconfig').setup({
        ensure_installed = { 'lua_ls', 'clangd', 'neocmake' },
        handlers = {
            lsp_zero.default_setup,
        },
    })
    require('lspconfig').lua_ls.setup({})

    local format_options = {
        format_opts = {
            async = false,
            timeout_ms = 10000,
        },
        servers = {
            ['lua_ls'] = { 'lua' },
            ['clangd'] = { 'c', 'cpp', 'c++' },
        }
    }

    lsp_zero.format_mapping('gq', format_options)
    lsp_zero.format_on_save(format_options)
end

return {
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        config = configure_lsp,
    },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'L3MON4D3/LuaSnip' },
}
