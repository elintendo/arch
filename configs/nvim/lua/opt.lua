vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.scrolloff = 5

vim.opt.autoread = true
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true

vim.opt.signcolumn = "yes"

vim.opt.completeopt:append({ "fuzzy", "menuone", "preview", "noinsert" })

vim.opt.showmode = false

vim.cmd.filetype("plugin indent on")

vim.cmd.colorscheme("retrobox")
