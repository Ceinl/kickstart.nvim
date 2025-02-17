-- Basic configuration --
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.cmd("autocmd BufReadPost * setlocal fileformat=unix")

-- Cursor navigation --
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.scrolloff = 15

-- Clipboard --
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Mouse and mode --
vim.opt.mouse = 'a'
vim.opt.showmode = false

-- Splits configuration --
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.breakindent = true

-- Undo and backup --
vim.opt.undofile = true

-- Search settings --
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'

-- Timeout and update settings --
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- List chars --
vim.opt.list = true
vim.opt.listchars = { tab = '| ', trail = '·', nbsp = '␣' }
vim.opt.shiftwidth = 4
