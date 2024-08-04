--# Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--# Scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

--# Clear search highlight
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
