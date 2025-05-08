return {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false,
    opts = {
        provider = 'copilot',
        behaviour = {
            use_cwd_as_project_root = true,
        },
    },
    build = 'make',
    dependencies = {
        'MunifTanjim/nui.nvim',
    },
}
