-- Visual
Pio.create_autocmd("Remember last cursor position", "BufReadPost", "*", function(args)
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
Pio.create_autocmd("Syntax highlighting for dotenv files", "BufRead", { ".env", ".env.*" }, function()
    vim.bo.filetype = "dosini"
end)
Pio.create_autocmd("Show cursorline only in active window: enable", { "WinEnter", "BufEnter" }, "*", function()
    vim.opt_local.cursorline = true
end)
Pio.create_autocmd("Show cursorline only in active window: disable", { "WinLeave", "BufLeave" }, "*", function()
    vim.opt_local.cursorline = false
end)
Pio.create_autocmd("Highlight on yank", "TextYankPost", "*", function()
    vim.highlight.on_yank()
end)
Pio.create_autocmd("Enable relative numbers in visual mode", "ModeChanged", "*:[vV\x16]*", function()
    vim.wo.relativenumber = true
end)
Pio.create_autocmd("Disable relative numbers leaving visual mode", "ModeChanged", "[vV\x16]*:*", function()
    vim.wo.relativenumber = string.find(vim.fn.mode(), "^[vV\22]") ~= nil
end)

-- Behavior
Pio.create_autocmd("No auto comment on new line", "FileType", "*", function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
end)
