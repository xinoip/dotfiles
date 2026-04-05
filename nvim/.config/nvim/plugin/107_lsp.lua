require("lazydev").setup({
    library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
})

-- Set 'omnifunc' to use `MiniCompletion` for LSP buffers.
local on_attach_mini_completions = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
end

local on_attach_lsp_keymaps = function(ev)
    local map = function(keys, func, desc)
        Pio.create_keymap("LSP: " .. desc, "n", keys, func, { buffer = ev.buf })
    end

    map("<leader>r", vim.lsp.buf.rename, "Rename")
    map("<leader>.", vim.lsp.buf.code_action, "Action")
    map("K", vim.lsp.buf.hover, "Info")
    map("<leader>d", vim.diagnostic.open_float, "Line Diagnostics")
    map("gd", vim.lsp.buf.definition, "Go to Definition")
end

local on_attach_highlight_under_cursor = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        Pio.create_autocmd_lsp(
            "LSP Highlight",
            { "CursorHold", "CursorHoldI" },
            ev.buf,
            nil,
            vim.lsp.buf.document_highlight
        )
        Pio.create_autocmd_lsp(
            "LSP Clear Highlight",
            { "CursorMoved", "CursorMovedI" },
            ev.buf,
            nil,
            vim.lsp.buf.clear_references
        )

        Pio.create_autocmd_lsp("LSP Detach Highlight", "LspDetach", ev.buf, nil, function(event2)
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
    on_attach_mini_completions(ev)
    on_attach_lsp_keymaps(ev)
    on_attach_highlight_under_cursor(ev)
    on_attach_toggle_inlay_hints(ev)
    on_attach_visual()
end

Pio.create_autocmd("Pio LSP Attach", "LspAttach", "*", nil, on_attach)

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, MiniCompletion.get_lsp_capabilities())
vim.lsp.config("*", { capabilities = capabilities })
