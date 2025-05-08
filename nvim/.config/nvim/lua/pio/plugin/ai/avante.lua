return {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false,
    opts = {
        provider = 'copilot',
    },
    build = 'make',
    dependencies = {
        'MunifTanjim/nui.nvim',
    },
}
