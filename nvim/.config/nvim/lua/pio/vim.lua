--# Visual
vim.wo.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.fillchars = { eob = " " }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10
vim.opt.showmode = false
vim.opt.termguicolors = true
vim.opt.cmdheight = 0
vim.opt.colorcolumn = "120"
vim.g.have_nerd_font = true
vim.opt.title = true
vim.opt.titlestring = "%t - Piovim"
vim.opt.foldenable = false
vim.opt.smoothscroll = true

--# Indentation
vim.opt.breakindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

--# Clipboard setup
vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)

--# History
vim.opt.undodir = os.getenv("HOME") .. "/.cache/vim_undodir"
vim.opt.undofile = true

--# Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

--# Tweak
vim.opt.mouse = "a"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.confirm = true
vim.opt.virtualedit = "block"
vim.opt.jumpoptions = "view"
vim.opt.completeopt = "menuone,noselect"
vim.g.python3_host_prog = os.getenv("HOME") .. "/3pp/pio-py/bin/python3"
