-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Scroll and center
Pio.create_keymap("Scroll down and center", "n", "<C-d>", "<C-d>zz")
Pio.create_keymap("Scroll up and center", "n", "<C-u>", "<C-u>zz")
Pio.create_keymap("Next search result and center", "n", "n", "nzz")
Pio.create_keymap("Prev search result and center", "n", "N", "Nzz")

-- Clear search highlight
Pio.create_keymap("Clear search highlight", "n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Keep indenting in visual mode
Pio.create_keymap("Indent left and stay in visual mode", "v", "<", "<gv")
Pio.create_keymap("Indent right and stay in visual mode", "v", ">", ">gv")

-- Join lines without moving cursor
Pio.create_keymap("Join lines without moving cursor", "n", "J", "m`J``")

-- Paste without yanking replaced text
Pio.create_keymap("Paste without yanking replaced text", "x", "p", '"_dP')

-- Buffer navigation
Pio.create_keymap("Prev buffer", "n", "[b", "<cmd>bprevious<CR>")
Pio.create_keymap("Next buffer", "n", "]b", "<cmd>bnext<CR>")

-- Quickfix navigation
Pio.create_keymap("Prev quickfix", "n", "[q", "<cmd>cprev<CR>")
Pio.create_keymap("Next quickfix", "n", "]q", "<cmd>cnext<CR>")

-- Diagnostic navigation
Pio.create_keymap("Prev diagnostic", "n", "[d", vim.diagnostic.goto_prev)
Pio.create_keymap("Next diagnostic", "n", "]d", vim.diagnostic.goto_next)

-- File path: show and yank
Pio.create_keymap("Copy file path", "n", "<leader>fp", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify(path, vim.log.levels.INFO, { title = "Path copied" })
end)
