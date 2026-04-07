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

-- -- Eagerly load LSP workspace-wide when launching Neovim on a project folder.
-- Pio.create_autocmd("Eagerly load LSP for workspace", "VimEnter", "*", nil, function()
--     local cwd = vim.uv.cwd()
--     if not cwd then
--         return
--     end
--
--     local markers = {
--         { name = "lua_ls", files = { ".luarc.json", "init.lua", ".luarc.jsonc" }, dummy = ".init.lua" },
--         { name = "gopls", files = { "go.mod", "go.sum" }, dummy = "main.go" },
--         {
--             name = "pyright",
--             files = { "pyproject.toml", "setup.py", "requirements.txt", "venv", ".venv" },
--             dummy = "main.py",
--         },
--         { name = "clangd", files = { "CMakeLists.txt", "Makefile", "configure.ac" }, dummy = "main.c" },
--     }
--
--     for _, marker in ipairs(markers) do
--         for _, file in ipairs(marker.files) do
--             if vim.uv.fs_stat(cwd .. "/" .. file) then
--                 local config = vim.lsp.config[marker.name]
--                 if config and config.cmd then
--                     -- Avoid 'file' URI errors for oil.nvim/netrw buffers.
--                     local is_file = vim.bo.buftype == "" and vim.fn.expand("%"):match("^%w+://") == nil
--
--                     if is_file then
--                         vim.lsp.start({
--                             name = marker.name,
--                             cmd = config.cmd,
--                             root_dir = cwd,
--                         })
--                     else
--                         -- Dummy scratch buffer to force-start the LSP.
--                         local temp_buf = vim.api.nvim_create_buf(false, true)
--                         vim.api.nvim_buf_set_name(temp_buf, cwd .. "/" .. marker.dummy)
--                         vim.lsp.start({
--                             name = marker.name,
--                             cmd = config.cmd,
--                             root_dir = cwd,
--                         }, { bufnr = temp_buf })
--                         vim.api.nvim_buf_delete(temp_buf, { force = true })
--                     end
--                     return
--                 end
--             end
--         end
--     end
-- end)
