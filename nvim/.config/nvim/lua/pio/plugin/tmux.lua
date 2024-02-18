return {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
    },
    config = function()
        vim.g.tmux_navigator_no_mappings = 1
        vim.keymap.set('n', '<M-Left>', '<cmd>TmuxNavigateLeft<cr>')
        vim.keymap.set('n', '<M-Right>', '<cmd>TmuxNavigateRight<cr>')
        vim.keymap.set('n', '<M-Up>', '<cmd>TmuxNavigateUp<cr>')
        vim.keymap.set('n', '<M-Down>', '<cmd>TmuxNavigateDown<cr>')
        vim.keymap.set('n', '<M-h>', '<cmd>TmuxNavigateLeft<cr>')
        vim.keymap.set('n', '<M-l>', '<cmd>TmuxNavigateRight<cr>')
        vim.keymap.set('n', '<M-k>', '<cmd>TmuxNavigateUp<cr>')
        vim.keymap.set('n', '<M-j>', '<cmd>TmuxNavigateDown<cr>')
    end
}
