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

Pio.create_autocmd("Disable Mini Completion in Snacks Picker", "FileType", "snacks_picker_input", function(args)
    vim.b[args.buf].minicompletion_disable = true
end)
