return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "modern",
        keys = {
            scroll_down = "<c-d>",
            scroll_up = "<c-u>",
        },
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
        vim.api.nvim_set_hl(0, "WhichKeyNormal", { bg = "#000000" })
    end,
}
