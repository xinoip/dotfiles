local map = Pio.create_keymap
local remap = function(desc, mode, lhs, rhs)
    map(desc, mode, lhs, rhs, { remap = true })
end

-- Leaders
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Navigation
map("Move down by visual line", "n", "j", "gj")
map("Move up by visual line", "n", "k", "gk")
map("Focus left window", "n", "<C-h>", "<C-w>h")
map("Focus down window", "n", "<C-j>", "<C-w>j")
map("Focus up window", "n", "<C-k>", "<C-w>k")
map("Focus right window", "n", "<C-l>", "<C-w>l")
map("Scroll down and center", "n", "<C-d>", "<C-d>zz")
map("Scroll up and center", "n", "<C-u>", "<C-u>zz")
map("Next search result and center", "n", "n", "nzz")
map("Prev search result and center", "n", "N", "Nzz")
map("Prev buffer", "n", "[b", "<cmd>bprevious<CR>")
map("Next buffer", "n", "]b", "<cmd>bnext<CR>")
map("Prev quickfix", "n", "[q", "<cmd>cprev<CR>")
map("Next quickfix", "n", "]q", "<cmd>cnext<CR>")
map("Prev diagnostic", "n", "[d", vim.diagnostic.goto_prev)
map("Next diagnostic", "n", "]d", vim.diagnostic.goto_next)
remap("Move left in insert", "i", "<M-h>", "<Left>")
remap("Move down in insert", "i", "<M-j>", "<Down>")
remap("Move up in insert", "i", "<M-k>", "<Up>")
remap("Move right in insert", "i", "<M-l>", "<Right>")
remap("Move left in command", "c", "<M-h>", "<Left>", { silent = false })
remap("Move right in command", "c", "<M-l>", "<Right>", { silent = false })

-- Visual
map("Clear search highlight", "n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Editing
map("Indent left and stay in visual mode", "v", "<", "<gv")
map("Indent right and stay in visual mode", "v", ">", ">gv")
map("Join lines without moving cursor", "n", "J", "m`J``")
map("Paste without yanking replaced text", "x", "p", '"_dP')

-- Utilities
map("Copy file path", "n", "<leader>fp", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify(path, vim.log.levels.INFO, { title = "Path copied" })
end)

-- Flash
map("2D Jump", "n", "s", function()
    require("flash").jump()
end)

-- Oil
map("Open parent directory", "n", "-", "<CMD>Oil<CR>")

-- Tmux
vim.g.tmux_navigator_no_mappings = 1
map("Tmux Navigate Left", "n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>")
map("Tmux Navigate Right", "n", "<C-l>", "<cmd>TmuxNavigateRight<cr>")
map("Tmux Navigate Up", "n", "<C-k>", "<cmd>TmuxNavigateUp<cr>")
map("Tmux Navigate Down", "n", "<C-j>", "<cmd>TmuxNavigateDown<cr>")

-- Conform
map("Format buffer", "n", "gq", function()
    require("conform").format({ async = true, lsp_fallback = true })
end)

-- Snacks
map("Resume picker", "n", "<leader>ff", function()
    Snacks.picker.resume()
end)
map("File picker", "n", "<C-p>", function()
    Snacks.picker.files({ hidden = true })
end)
map("Grep picker", "n", "<leader>fg", function()
    Snacks.picker.grep()
end)
map("Buffer picker", "n", "<leader>fb", function()
    Snacks.picker.buffers()
end)
map("Help pages", "n", "<leader>fh", function()
    Snacks.picker.help()
end)
map("Man pages", "n", "<leader>fm", function()
    Snacks.picker.man()
end)
map("File explorer", "n", "<leader>e", function()
    Snacks.explorer()
end)
map("Goto Definition", "n", "gd", function()
    Snacks.picker.lsp_definitions()
end)
map("Goto Declaration", "n", "gD", function()
    Snacks.picker.lsp_declarations()
end)
map("Goto References", "n", "gr", function()
    Snacks.picker.lsp_references()
end)
map("Goto Implementation", "n", "gI", function()
    Snacks.picker.lsp_implementations()
end)
map("Zen Mode", "n", "<leader>z", function()
    Snacks.zen()
end)
map("LSP Symbols", "n", "<leader>fo", function()
    Snacks.picker.lsp_symbols()
end)
map("LSP Workspace Symbols", "n", "<leader>fO", function()
    Snacks.picker.lsp_workspace_symbols()
end)
map("Toggle Wrap", "n", "<leader>uw", function()
    Snacks.toggle.option("wrap", { name = "Wrap" }):toggle()
end)
map("Toggle Diagnostics", "n", "<leader>ud", function()
    Snacks.toggle.diagnostics():toggle()
end)
