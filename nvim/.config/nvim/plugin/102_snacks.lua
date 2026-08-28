require("snacks").setup({
    styles = {
        zen = {
            enter = true,
            fixbuf = false,
            minimal = true,
            width = 160,
            height = 0,
            backdrop = { transparent = false },
            keys = { q = false },
            zindex = 40,
            wo = {
                winhighlight = "NormalFloat:Normal",
            },
            w = {
                snacks_main = true,
            },
        },
    },

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
    zen = {
        enabled = true,
        toggles = {
            dim = false,
            git_signs = true,
            mini_diff_signs = true,
            diagnostics = true,
            inlay_hints = true,
        },
        center = true,
        show = {
            statusline = true, -- TODO: Center it.
            tabline = false,
        },

        win = {
            style = "zen",
        },
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
