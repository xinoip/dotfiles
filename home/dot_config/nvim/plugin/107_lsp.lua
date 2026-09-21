require("lazydev").setup({
    library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
})

require("flutter-tools").setup({})

local on_attach_lsp_keymaps = function(ev)
    local map = function(keys, func, desc)
        Pio.create_keymap("LSP: " .. desc, "n", keys, func, { buffer = ev.buf })
    end

    map("<leader>r", vim.lsp.buf.rename, "Rename")
    map("<leader>.", require("tiny-code-action").code_action, "Action")
    map("K", function()
        vim.lsp.buf.hover({
            border = "rounded",
            max_width = 80,
        })
    end, "Info")
    map("<leader>d", vim.diagnostic.open_float, "Line Diagnostics")
    -- take a look at Snacks keymaps for more LSP keymaps
end

local on_attach_highlight_under_cursor = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        Pio.create_autocmd_lsp("LSP Highlight", { "CursorHold", "CursorHoldI" }, ev.buf, vim.lsp.buf.document_highlight)
        Pio.create_autocmd_lsp(
            "LSP Clear Highlight",
            { "CursorMoved", "CursorMovedI" },
            ev.buf,
            vim.lsp.buf.clear_references
        )

        Pio.create_autocmd_lsp("LSP Detach Highlight", "LspDetach", ev.buf, function(event2)
            vim.lsp.buf.clear_references()
            Pio.clear_autocmd_lsp(event2.buf)
        end)
    end
end

local on_attach_toggle_inlay_hints = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        local map = function(keys, func, desc)
            Pio.create_keymap("LSP: " .. desc, "n", keys, func, { buffer = ev.buf })
        end

        map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }))
        end, "Toggle Inlay Hints")
    end
end

local on_attach_visual = function()
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
end

local on_attach = function(ev)
    on_attach_lsp_keymaps(ev)
    on_attach_highlight_under_cursor(ev)
    on_attach_toggle_inlay_hints(ev)
    on_attach_visual()
end

Pio.create_autocmd("Pio LSP Attach", "LspAttach", "*", on_attach)

local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config("harper_ls", {
    settings = {
        ["harper-ls"] = {
            userDictPath = vim.fn.expand("~/vault/.harper-dictionary.txt"),
            linters = {
                UseTitleCase = false,
                GoogleNames = false,
            },
        },
    },
})

vim.lsp.config("jsonls", {
    settings = {
        ["jsonls"] = {
            json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
            },
        },
    },
})

vim.lsp.config("yamlls", {
    settings = {
        ["yamlls"] = {
            schemaStore = {
                -- You must disable built-in schemaStore support if you want to use
                -- this plugin and its advanced options like `ignore`.
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
        },
    },
})

require("tiny-inline-diagnostic").setup()
vim.diagnostic.config({ virtual_text = false })
