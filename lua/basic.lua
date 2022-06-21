-- use space as the leader key
vim.g.mapleader=' '

vim.cmd[[set mouse=a]]
vim.cmd[[set nowrap]]

vim.o.hidden = true

-- needed by nvim-compe
vim.o.completeopt="menuone,noselect"

vim.o.relativenumber=true
vim.o.number=true
vim.o.tabstop=4
vim.o.shiftwidth=4
vim.o.smartcase=true
vim.o.scrolloff=25
vim.o.cursorline=true
vim.o.incsearch=true
vim.o.termguicolors=true
vim.o.clipboard="unnamedplus"
-- Set updatetime for CursorHold
-- 300ms of no cursor movement to trigger CursorHold
vim.o.updatetime=300

vim.wo.colorcolumn="120"
