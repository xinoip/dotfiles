require("snacks").setup({
    bigfile = { enabled = true },
    explorer = { enabled = true },
    image = { enabled = true },
    -- indent = { enabled = true },
    input = { enabled = true },
    picker = {
        enabled = true,
        main = { current = true },
        layout = {
            layout = {
                width = 0.9,
                height = 0.9,
            },
        },
        sources = { explorer = { layout = { layout = { width = 0.2 } } } },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
    scroll = {
        enabled = false,
        animate = {
            duration = { step = 5, total = 200 },
            easing = "outCubic",
        },
        animate_repeat = {
            delay = 50,
            duration = { step = 2, total = 50 },
            easing = "outCubic",
        },
    },
    dashboard = {
        enabled = true,
        sections = {
            { section = "header" },
            { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
            { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
            { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
            -- { section = "startup" },
            {
                section = "terminal",
                cmd = "exec ~/.config/zsh/pokemon-colorscripts/pokemon-colorscripts -r --no-title",
                random = 10,
                pane = 2,
                indent = 4,
                height = 30,
            },
        },
    },
})

Pio.create_keymap("Resume picker", "n", "<leader>ff", function()
    Snacks.picker.resume()
end)
Pio.create_keymap("File picker", "n", "<C-p>", function()
    Snacks.picker.files({ hidden = true })
end)
Pio.create_keymap("Grep picker", "n", "<leader>fg", function()
    Snacks.picker.grep()
end)
Pio.create_keymap("Buffer picker", "n", "<leader>fb", function()
    Snacks.picker.buffers()
end)
Pio.create_keymap("Help pages", "n", "<leader>fh", function()
    Snacks.picker.help()
end)
Pio.create_keymap("Man pages", "n", "<leader>fm", function()
    Snacks.picker.man()
end)
Pio.create_keymap("File explorer", "n", "<leader>e", function()
    Snacks.explorer()
end)
Pio.create_keymap("Goto Definition", "n", "gd", function()
    Snacks.picker.lsp_definitions()
end)
Pio.create_keymap("Goto Declaration", "n", "gD", function()
    Snacks.picker.lsp_declarations()
end)
Pio.create_keymap("Goto References", "n", "gr", function()
    Snacks.picker.lsp_references()
end)
Pio.create_keymap("Goto Implementation", "n", "gI", function()
    Snacks.picker.lsp_implementations()
end)
Pio.create_keymap("Zen Mode", "n", "<leader>z", function()
    Snacks.zen()
end)
Pio.create_keymap("LSP Symbols", "n", "<leader>fo", function()
    Snacks.picker.lsp_symbols()
end)
Pio.create_keymap("LSP Workspace Symbols", "n", "<leader>fO", function()
    Snacks.picker.lsp_workspace_symbols()
end)

Pio.create_autocmd("Snacks Toggles", "User", "VeryLazy", nil, function()
    -- Create some toggle mappings
    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
    Snacks.toggle.diagnostics():map("<leader>ud")
end)

Pio.create_autocmd("Disable Mini Completion in Snacks Picker", "FileType", "snacks_picker_input", nil, function(args)
    vim.b[args.buf].minicompletion_disable = true
end)
