Pio.create_autocmd("Remember last cursor position", "BufReadPost", "*", nil, function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
        vim.api.nvim_win_set_cursor(0, mark)
        -- defer centering slightly so it's applied after render
        vim.schedule(function()
            vim.cmd("normal! zz")
        end)
    end
end)

Pio.create_autocmd("Open help in vertical split", "FileType", "help", "wincmd L")

Pio.create_autocmd("Resize splits on terminal resize", "VimResized", "*", "wincmd =")

Pio.create_autocmd("No auto comment on new line", "FileType", "*", nil, function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
end)

Pio.create_autocmd("Syntax highlighting for dotenv files", "BufRead", { ".env", ".env.*" }, nil, function()
    vim.bo.filetype = "dosini"
end)

Pio.create_autocmd("Show cursorline only in active window: enable", { "WinEnter", "BufEnter" }, "*", nil, function()
    vim.opt_local.cursorline = true
end)

Pio.create_autocmd("Show cursorline only in active window: disable", { "WinLeave", "BufLeave" }, "*", nil, function()
    vim.opt_local.cursorline = false
end)

Pio.create_autocmd("Highlight on yank", "TextYankPost", "*", nil, function()
    vim.highlight.on_yank()
end)
