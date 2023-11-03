vim.cmd([[set mouse-=a]])

-- 搜索忽略大小写
vim.opt.ignorecase = true

-- 禁止折行
vim.wo.wrap = false
-- utf8
vim.g.encoding = "UTF-8"
vim.o.fileencoding = "utf-8"

vim.o.hidden = true

-- needed by nvim-compe
vim.o.completeopt = "menuone,noselect"

vim.o.relativenumber = true
vim.o.number = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smartcase = true
vim.o.scrolloff = 10
vim.o.cursorline = true
vim.o.incsearch = true
vim.o.spelllang = "en"
vim.o.clipboard = "unnamedplus"
-- Set updatetime for CursorHold
-- 300ms of no cursor movement to trigger CursorHold
vim.o.updatetime = 300

vim.wo.colorcolumn = "120"
vim.o.fileformats = "unix"

-- 自动补全不自动选中
vim.g.completeopt = "menu,menuone,noselect,noinsert"
-- 样式 使neovim支持 termguicolors
vim.o.termguicolors = true
vim.opt.termguicolors = true

-- 使用增强状态栏插件后不再需要 vim 的模式提示
vim.o.showmode = false
