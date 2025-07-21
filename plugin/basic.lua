--vim.opt: behaves like :set
--vim.opt_global: behaves like :setglobal
--vim.opt_local: behaves like :setlocal

--vim.o: behaves like :set
--vim.go: behaves like :setglobal, like let g: in vim script
--vim.bo: for buffer-scoped options
--vim.wo: for window-scoped options (can be double indexed)

vim.g.mapleader = " "

vim.cmd([[set mouse-=a]])

-- 搜索忽略大小写
vim.opt.ignorecase = true

-- 禁止折行
vim.wo.wrap = false
-- utf8
vim.g.encoding = "UTF-8"
vim.o.fileencoding = "utf-8"

vim.o.hidden = true

vim.o.relativenumber = true
vim.o.number = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.autoindent = true
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
vim.o.fileformats = "unix,dos"

-- 自动补全不自动选中
vim.g.completeopt = "menu,menuone,noselect,noinsert"
-- 样式 使neovim支持 termguicolors
vim.o.termguicolors = true
vim.opt.termguicolors = true

-- 使用增强状态栏插件后不再需要 vim 的模式提示
vim.o.showmode = false
vim.o.hidden = false

if require("utils").IsWindows() then
  -- use pwsh on windows
  vim.opt.shell = vim.fn.executable("pwsh") and "pwsh" or "powershell"
  vim.opt.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
  vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end

vim.filetype.add({
  extension = {
    rasi = "rasi",
  },
})

vim.o.exrc = true
