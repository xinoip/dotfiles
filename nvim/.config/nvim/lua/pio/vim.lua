--# Visual
vim.wo.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.showmode = false
vim.opt.termguicolors = true
vim.opt.cmdheight = 0
vim.opt.colorcolumn = '92'
vim.g.have_nerd_font = true
vim.opt.title = true
vim.opt.titlestring = '%t - Piovim'

--# Indentation
vim.opt.breakindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

--# Clipboard setup
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

--# History
vim.opt.undodir = os.getenv 'HOME' .. '/.cache/vim_undodir'
vim.opt.undofile = true

--# Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

--# Tweak
vim.opt.mouse = 'a'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.completeopt = 'menuone,noselect'
vim.g.python3_host_prog = os.getenv 'HOME' .. '/3pp/pio-py/bin/python3'

--# Highlight when copying text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

--# Custom commands
vim.api.nvim_create_user_command('FormatDisable', function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
    print 'Format on save disabled'
end, {
    desc = 'Disable autoformat-on-save',
    bang = true,
})
vim.api.nvim_create_user_command('FormatEnable', function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
    print 'Format on save enabled'
end, {
    desc = 'Re-enable autoformat-on-save',
})
