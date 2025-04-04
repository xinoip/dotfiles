return {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
        vim.g.gruvbox_material_enable_italic = true
        vim.g.gruvbox_material_background = 'hard'
        vim.g.gruvbox_material_enable_bold = true
        vim.g.gruvbox_material_transparent_background = 2
        vim.g.gruvbox_material_ui_contrast = 'high'
        vim.g.gruvbox_material_diagnostic_text_highlight = true
        vim.g.gruvbox_material_diagnostic_line_highlight = true
        vim.g.gruvbox_material_diagnostic_virtual_text = 'highlighted'
        vim.g.gruvbox_material_better_performance = true

        vim.cmd.colorscheme 'gruvbox-material'
    end,
}
