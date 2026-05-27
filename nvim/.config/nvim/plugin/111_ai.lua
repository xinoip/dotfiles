require("minuet").setup({
    virtualtext = {
        auto_trigger_ft = { "*" },
        keymap = {
            -- accept whole completion
            accept = "<A-A>",
            -- accept one line
            accept_line = "<A-a>",
            -- accept n lines (prompts for number)
            -- e.g. "A-z 2 CR" will accept 2 lines
            accept_n_lines = "<A-z>",
            -- Cycle to prev completion item, or manually invoke completion
            prev = "<A-[>",
            -- Cycle to next completion item, or manually invoke completion
            next = "<A-]>",
            dismiss = "<A-e>",
        },
    },
    provider = "openai_compatible",
    request_timeout = 2.5,
    throttle = 1500, -- Increase to reduce costs and avoid rate limits
    debounce = 600, -- Increase to reduce costs and avoid rate limits
    provider_options = {
        openai_compatible = {
            api_key = "OPENCODE_GO_API_KEY",
            end_point = "https://opencode.ai/zen/go/v1/chat/completions",
            model = "deepseek-v4-flash",
            name = "Opencode",
            optional = {
                max_tokens = 56,
                top_p = 0.9,
                -- disable thinking to avoid first token latency
                thinking = { type = "disabled" },
            },
        },
    },
})

local copy_context = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local relative_path = vim.fn.fnamemodify(filename, ":.")
    if vim.startswith(relative_path, "/") or vim.startswith(relative_path, "~") then
        relative_path = filename
    end
    local mode = vim.fn.mode()
    local result
    if mode == "v" or mode == "V" or mode == "" then
        local start_pos = vim.fn.getpos("v")
        local end_pos = vim.fn.getpos(".")
        local start_line = math.min(start_pos[2], end_pos[2])
        local end_line = math.max(start_pos[2], end_pos[2])
        if start_line == end_line then
            result = string.format("@%s:%d", relative_path, start_line)
        else
            result = string.format("@%s:%d-%d", relative_path, start_line, end_line)
        end
    else
        local current_line = vim.fn.line(".")
        result = string.format("@%s:%d", relative_path, current_line)
    end
    vim.fn.setreg("+", result)
    vim.fn.setreg('"', result)
    vim.notify(string.format("Copied to clipboard: %s", result), vim.log.levels.INFO)
end

Pio.create_cmd("CopyContext", "Copy file path with line numbers for context", copy_context, { range = true })

Pio.create_keymap("Copy Context", { "n", "v" }, "<leader>cc", copy_context, { silent = true })
