return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "gq",
            function()
                require("conform").format({ async = true, lsp_fallback = true })
            end,
            mode = "",
            desc = "[F]ormat buffer",
        },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
            -- Disable globally
            if not vim.g.pio_format then
                return
            end

            -- Disable by file
            local ignore_filetypes = { "java", "html" }
            if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
                return
            end

            -- Disable by folder/path
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if bufname:match("/node_modules/") then
                return
            end

            return { timeout_ms = 500, lsp_format = "fallback" }
        end,
        formatters_by_ft = {
            python = { "isort", "black" },
            lua = { "stylua" },
            cmake = { "cmake_format" },

            -- First check if project has prettier, else use prettierd
            javascript = { "prettier", "prettierd", stop_after_first = true },
            javascriptreact = { "prettier", "prettierd", stop_after_first = true },
            typescript = { "prettier", "prettierd", stop_after_first = true },
            typescriptreact = { "prettier", "prettierd", stop_after_first = true },
            html = { "prettier", "prettierd", stop_after_first = true },
            json = { "prettier", "prettierd", stop_after_first = true },
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
        },
    },
}
