return {
    "dgox16/oldworld.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        local oldworld = require("oldworld")
        oldworld.setup({
            variant = "oled",
        })
        vim.cmd.colorscheme("oldworld")
    end,
}
