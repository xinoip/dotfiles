return {
    "yetone/avante.nvim",
    build = "make",
    event = "VeryLazy",
    version = false,
    opts = {
        instructions_file = "AGENTS.md",
        provider = "copilot",
        providers = {
            copilot = {
                model = "gpt-5-mini",
            },
        },
        behaviour = {
            use_cwd_as_project_root = true,
        },
    },
}
