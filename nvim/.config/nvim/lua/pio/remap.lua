--# Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--# Scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

--# Clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

--# Keep indenting in visual mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

--# Join lines without moving cursor
vim.keymap.set("n", "J", "m`J``")

--# Paste without yanking replaced text
vim.keymap.set("x", "p", '"_dP')

--# Buffer navigation
vim.keymap.set("n", "[b", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })

--# Quickfix navigation
vim.keymap.set("n", "[q", "<cmd>cprev<CR>", { desc = "Prev quickfix" })
vim.keymap.set("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix" })

--# Diagnostic navigation
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

--# File path: show and yank
vim.keymap.set("n", "<leader>fp", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify(path, vim.log.levels.INFO, { title = "Path copied" })
end, { desc = "Copy file path" })
