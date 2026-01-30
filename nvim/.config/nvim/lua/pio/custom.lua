-- Toggle all animations on/off
vim.g.pio_animate = false
vim.api.nvim_create_user_command("PioAnimate", function()
    local smear = require("smear_cursor")
    vim.g.pio_animate = not vim.g.pio_animate

    smear.enabled = vim.g.pio_animate

    if vim.g.pio_animate then
        Snacks.scroll.enable()
    else
        Snacks.scroll.disable()
    end

    vim.notify("Animations: " .. (vim.g.pio_animate and "on" or "off"))
end, {
    desc = "Toggle animations",
})

-- Toggle format on save
vim.g.pio_format = true
vim.api.nvim_create_user_command("PioFormat", function()
    vim.g.pio_format = not vim.g.pio_format
    vim.notify("Format on save: " .. (vim.g.pio_format and "on" or "off"))
end, {
    desc = "Disable format on save",
})
