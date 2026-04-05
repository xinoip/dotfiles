-- TODO: currently broken
vim.g.pio_animate = false
Pio.create_cmd("PioAnimate", "Toggle animations", function()
    local smear = require("smear_cursor")
    vim.g.pio_animate = not vim.g.pio_animate

    smear.enabled = vim.g.pio_animate

    if vim.g.pio_animate then
        Snacks.scroll.enable()
    else
        Snacks.scroll.disable()
    end

    vim.notify("Animations: " .. (vim.g.pio_animate and "on" or "off"))
end)

vim.g.pio_format = true
Pio.create_cmd("PioFormat", "Toggle format on save", function()
    vim.g.pio_format = not vim.g.pio_format
    vim.notify("Format on save: " .. (vim.g.pio_format and "on" or "off"))
end)
