require("blink.cmp").setup({
    keymap = {
        preset = "none",
        ["<CR>"] = { "hide", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<C-y>"] = { "select_and_accept", "fallback" },
    },

    completion = {
        list = {
            selection = {
                preselect = true,
                auto_insert = true,
            },
        },
        menu = {
            border = "rounded",
            draw = {
                columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
            },
        },
        documentation = {
            auto_show = true,
            window = { border = "rounded" },
        },
    },

    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },

    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
    },
})

Pio.create_cmd("PioBuildBlink", "Build blink.cmp with cargo/rust", function()
    vim.notify("Building blink.cmp...", vim.log.levels.INFO)
    require("blink.cmp").build():wait(60000)
end)
