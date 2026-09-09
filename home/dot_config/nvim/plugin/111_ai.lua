require("supermaven-nvim").setup({})

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
