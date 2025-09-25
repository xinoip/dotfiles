return {
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Mason must be loaded first, before all dependencies
        { 'williamboman/mason.nvim', opts = {} },
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',

        -- LSP status updates
        { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc)
                    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                end

                map('<leader>r', vim.lsp.buf.rename, 'LSP Rename')
                map('<leader>.', vim.lsp.buf.code_action, 'LSP Action')
                map('K', vim.lsp.buf.hover, 'LSP Info')
                map('<leader>d', vim.diagnostic.open_float, 'LSP Line Diagnostics')

                -- Highlight under cursor / Clear when moved out
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                    local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd('LspDetach', {
                        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                        end,
                    })
                end

                -- Toggle inlay hints
                if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                    map('<leader>th', function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                    end, '[T]oggle Inlay [H]ints')
                end
            end,
        })

        -- Capabilities such as snippets, cmp etc.
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local blink_capabilities = require('blink.cmp').get_lsp_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, blink_capabilities)

        -- Servers to install
        --  cmd (table): Override the default command used to start the server
        --  filetypes (table): Override the default list of associated filetypes for the server
        --  capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
        --  settings (table): Override the default settings passed when initializing the server.
        local servers = {
            clangd = {},
            neocmake = {},
            lua_ls = {
                -- cmd = {...},
                -- filetypes = { ...},
                -- capabilities = {},
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = 'Replace',
                        },
                        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                        -- diagnostics = { disable = { 'missing-fields' } },
                    },
                },
            },
            gopls = {},
            bashls = {},
            -- ts_ls = {},
            sqlls = {},
            templ = {},
            pyright = {},
        }

        -- Let Mason install the servers, check with :Mason
        require('mason').setup()

        -- Let Mason install tools
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            'stylua', -- Used to format Lua code
            'cmakelang', -- cmake-format
            'shfmt', -- bash-language-server formatter
            'shellcheck', -- bash-language-server linter
            'isort', -- Python formatter
            'black', -- Python formatter
            'prettierd', -- JS/TS formatter
            'marksman', -- markdown lsp
        })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }

        require('mason-lspconfig').setup {
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    -- This handles overriding only values explicitly passed
                    -- by the server configuration above. Useful when disabling
                    -- certain features of an LSP (for example, turning off formatting for tsserver)
                    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                    require('lspconfig')[server_name].setup(server)
                end,
            },
        }
    end,
}
