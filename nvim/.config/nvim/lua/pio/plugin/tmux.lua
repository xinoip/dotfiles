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
    end
}
