return {
    'echasnovski/mini.nvim',
    config = function()
        require('mini.ai').setup()
        -- require('mini.bracketed').setup()
        require('mini.cursorword').setup()
        -- require('mini.surround').setup()
    end
}
