return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    opts = {
        instructions_file = "AGENTS.md",
        provider = "copilot",
        behaviour = {
            use_cwd_as_project_root = true,
        },
    },
    build = "make",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
}
