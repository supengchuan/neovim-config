-- use space as the leader key
vim.g.mapleader = " "

vim.cmd([[set mouse-=a]])
vim.cmd([[set nowrap]])

vim.o.hidden = true

-- needed by nvim-compe
vim.o.completeopt = "menuone,noselect"

vim.o.relativenumber = true
vim.o.number = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smartcase = true
vim.o.scrolloff = 25
vim.o.cursorline = true
vim.o.incsearch = true
vim.o.termguicolors = true
vim.o.spelllang = en
vim.o.clipboard = "unnamedplus"
-- Set updatetime for CursorHold
-- 300ms of no cursor movement to trigger CursorHold
vim.o.updatetime = 300

vim.wo.colorcolumn = "120"

-- set code fold using ufo
--vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
--vim.o.foldlevelstart = 99
--vim.o.foldenable = true
--vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
--vim.o.foldcolumn = '1'
------ Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
--vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
--vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
