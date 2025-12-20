return {
    "saghen/blink.cmp",

    -- Uses built binaries from releases
    version = "1.*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = { preset = "default" },
        appearance = {
            nerd_font_variant = "mono",
        },
        -- TODO: check this
        completion = { documentation = { auto_show = true } },
        -- TODO: lazydev not working
        sources = {
            -- default = { "lazydev", "lsp", "path", "snippets", "buffer" },
            default = { "lsp", "path", "snippets", "buffer" },
        },
        -- providers = {
        --     lazydev = {
        --         name = "LazyDev",
        --         module = "lazydev.integrations.blink",
        --         score_offset = 100,
        --     },
        -- },
        fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
}
