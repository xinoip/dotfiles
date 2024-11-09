return {
    'ggandor/leap.nvim',
    dependencies = { 'tpope/vim-repeat' },
    config = function()
        local leap = require 'leap'

        leap.opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }
        leap.opts.special_keys.prev_target = '<backspace>'
        leap.opts.special_keys.prev_group = '<backspace>'

        vim.keymap.set('n', 'S', '<Plug>(leap)')
        -- vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
        vim.keymap.set({ 'x', 'o' }, 'S', '<Plug>(leap-forward)')
        -- vim.keymap.set({ 'x', 'o' }, 'S', '<Plug>(leap-backward)')

        require('leap.user').set_repeat_keys('<enter>', '<backspace>')
    end,
}
