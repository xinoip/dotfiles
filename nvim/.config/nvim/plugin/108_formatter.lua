require("conform").setup({
    notify_on_error = false,
    format_on_save = function()
        -- Disable globally
        if not vim.g.pio_format then
            return
        end

        return { timeout_ms = 500, lsp_format = "fallback" }
    end,
    formatters_by_ft = {
        python = { "isort", "black" },
        lua = { "stylua" },
        cmake = { "cmake_format" },
        go = { "golines" },
        markdown = { "rumdl" },

        -- First check if project has prettier, else fallback to prettierd or other formatters
        javascript = { "prettier", "prettierd", stop_after_first = true },
        javascriptreact = { "prettier", "prettierd", stop_after_first = true },
        typescript = { "prettier", "prettierd", stop_after_first = true },
        typescriptreact = { "prettier", "prettierd", stop_after_first = true },
        html = { "prettier", "prettierd", stop_after_first = true },
        json = { "prettier", "jq", "prettierd", stop_after_first = true },
        liquid = { "prettier", "prettierd", stop_after_first = true },
    },
    formatters = {
        prettierd = {
            prepend_args = function()
                return {
                    "--no-semi",
                    "--single-quote",
                    "--no-bracket-spacing",
                    "--print-width",
                    "80",
                    "--config-precedence",
                    "prefer-file",
                }
            end,
        },
        golines = {
            append_args = function()
                return {
                    "--max-len=120",
                }
            end,
        },
    },
})
