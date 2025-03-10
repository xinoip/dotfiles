return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "modern",
        keys = {
            scroll_down = "<c-d>",
            scroll_up = "<c-u>",
        },
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
    config = function()
        vim.api.nvim_set_hl(0, "WhichKeyNormal", { bg = "#141617" })
    end
}
