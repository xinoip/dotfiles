vim.g.tmux_navigator_no_mappings = 1
Pio.create_keymap("Tmux Navigate Left", "n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>")
Pio.create_keymap("Tmux Navigate Right", "n", "<C-l>", "<cmd>TmuxNavigateRight<cr>")
Pio.create_keymap("Tmux Navigate Up", "n", "<C-k>", "<cmd>TmuxNavigateUp<cr>")
Pio.create_keymap("Tmux Navigate Down", "n", "<C-j>", "<cmd>TmuxNavigateDown<cr>")
