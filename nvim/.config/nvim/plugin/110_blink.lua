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
        ["<esc>"] = { "hide", "fallback" },
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
    local path = vim.fn.stdpath("data") .. "/site/pack/core/opt/blink.cmp"
    vim.notify("Building blink.cmp...", vim.log.levels.INFO)
    vim.system({ "cargo", "build", "--release" }, { cwd = path }, function(obj)
        if obj.code ~= 0 then
            vim.schedule(function()
                vim.notify("Failed to build blink.cmp: " .. obj.stderr, vim.log.levels.ERROR)
            end)
        else
            vim.schedule(function()
                vim.notify("Successfully built blink.cmp", vim.log.levels.INFO)
            end)
        end
    end)
end)
