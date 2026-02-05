local servers = {
    "clangd",
    "neocmake",
    "lua_ls",
    "gopls",
    "bashls",
    "sqlls",
    "templ",
    "pyright",
    "markdown-oxide",
}

local tools = {
    "stylua",
    "cmakelang",
    "shfmt",
    "shellcheck",
    "isort",
    "black",
    "prettierd",
    "protols",
    "harper-ls",
}

return {
    -- Manage up-to-date configurations for LSP servers
    {
        "neovim/nvim-lspconfig",

        config = function()
            -- Keymaps
            -- Rest of the keybindings are defined by snacks.nvim
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    map("<leader>r", vim.lsp.buf.rename, "LSP Rename")
                    map("<leader>.", vim.lsp.buf.code_action, "LSP Action")
                    map("K", vim.lsp.buf.hover, "LSP Info")
                    map("<leader>d", vim.diagnostic.open_float, "LSP Line Diagnostics")

                    -- Highlight under cursor / Clear when moved out
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                        local highlight_augroup =
                            vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd("LspDetach", {
                            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
                            end,
                        })
                    end

                    -- Toggle inlay hints
                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                        map("<leader>th", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                        end, "[T]oggle Inlay [H]ints")
                    end
                end,
            })

            -- Visual stuff
            local severity = vim.diagnostic.severity
            vim.diagnostic.config({
                signs = {
                    text = {
                        [severity.ERROR] = " ",
                        [severity.WARN] = " ",
                        [severity.HINT] = "󰠠 ",
                        [severity.INFO] = " ",
                    },
                },
            })
        end,
    },

    -- Install LSP servers
    {
        "mason-org/mason.nvim",
        opts = {},
    },

    -- Ensure LSP servers are installed and configured
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = servers,
        },
    },

    -- Ensure tools are installed such as formatters linters etc.
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = {
            ensure_installed = tools,
        },
    },
}
