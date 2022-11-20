-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

local keybindingAlias = require("keybindingAlias")
-- silent = true 结果不会在command栏显示 为false会在command栏显示
local opt = { noremap = true, silent = true }

-- leader key "<space>"
vim.g.mapleader = keybindingAlias.norl.leader_key
--vim.g.maplocalleader = keybindingAlias.norl.leader_key

local map = vim.api.nvim_set_keymap

-- 取消insert模式下 f1键的默认功能
map("i", "<F1>", "", opt)

-- insert模式下键盘映射
local inser = keybindingAlias.insert
map("i", inser.goto_command_mode, "<Esc>:", { noremap = true, silent = false })

--  bufferline.nvim
local bufferline = keybindingAlias.bufferline
map("n", bufferline.BufferLineCyclePrev, ":BufferLineCyclePrev<CR>", opt)
map("n", bufferline.BufferLineCycleNext, ":BufferLineCycleNext<CR>", opt)
map("n", bufferline.BufferLinePick, ":BufferLinePick<CR>", opt)
map("n", bufferline.BufferLinePickClose, ":BufferLinePickClose<CR>", opt)
-- buffuer select
map("n", bufferline.ToBuffer1, "<Cmd>BufferLineGoToBuffer 1<CR>", opt)
map("n", bufferline.ToBuffer2, "<Cmd>BufferLineGoToBuffer 2<CR>", opt)
map("n", bufferline.ToBuffer3, "<Cmd>BufferLineGoToBuffer 3<CR>", opt)
map("n", bufferline.ToBuffer4, "<Cmd>BufferLineGoToBuffer 4<CR>", opt)
map("n", bufferline.ToBuffer5, "<Cmd>BufferLineGoToBuffer 5<CR>", opt)
map("n", bufferline.ToBuffer6, "<Cmd>BufferLineGoToBuffer 6<CR>", opt)
map("n", bufferline.ToBuffer7, "<Cmd>BufferLineGoToBuffer 7<CR>", opt)

-- 取消normal模式下 H L键默认功能
map("n", "<F1>", "", opt)
map("n", "H", "", opt)
map("n", "L", "", opt)
--
local norl = keybindingAlias.norl
map("n", norl.goto_command_mode, ":", { noremap = true, silent = false })

map("n", norl.go_left35, "35h", opt)
map("n", norl.go_right35, "35l", opt)
-- quick move
map("n", norl.go_up_10line, "10j", opt)
map("n", norl.go_down_10line, "10k", opt)

-- write
-- save and exit
map("n", norl.save_window, "<cmd>w<CR>", opt)
map("n", norl.quit_window, "<cmd>q<CR>", opt)
map("n", "<leader>nl", "<cmd>nohlsearch<CR>", opt)

-- open outline
map("n", "<leader>o", ":AerialToggle<CR>", opt)

-- resize
map("n", "<leader>=", "<cmd>vertical resize +10<CR>", opt)
map("n", "<leader>-", "<cmd>vertical resize -10<CR>", opt)
-- format
map("n", "<leader>f", "<cmd>Format<CR>", opt)

-- nvim-tree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", opt)

-- 窗口之间跳转
-- use ctrl-hjkl move cursor between windows
map("n", "<C-h>", "<C-w>h", opt)
map("n", "<C-j>", "<C-w>j", opt)
map("n", "<C-k>", "<C-w>k", opt)
map("n", "<C-l>", "<C-w>l", opt)

local pluginKeys = {}
-- toggleterm
-- <leader>t 浮动
-- <C-t> close
local toggletermm = keybindingAlias.toggerterm
pluginKeys.mapToggleTerm = function(toggleterm)
	vim.keymap.set("n", toggletermm.open_float, toggleterm.toggle)
	vim.keymap.set("t", toggletermm.hide, toggleterm.toggle)
end

map("n", "<leader>i", "<cmd>lua vim.diagnostic.open_float()<CR>", opt)
map("n", "<leader>d[", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opt)
map("n", "<leader>d]", "<cmd>lua vim.diagnostic.goto_next()<CR>", opt)
map("n", "<leader>dd", "<cmd>Telescope diagnostics<CR>", opt)
map("n", "<C-q>", "<cmd>lua vim.lsp.buf.hover()<CR>", opt)
-- show parameter hint
map("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opt)
-- go to definition
map("n", "<C-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", opt)
map("n", "gr", "<cmd>Telescope lsp_references<CR>", opt)
map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opt)

-- double j to normal mode
map("i", "jj", "<ESC>", { noremap = true })
map("i", "<Tab>", "vsnip#jumpable(1)?'<Plug>(vsnip-jump-next)':'<Tab>'", opt)

-- dap
map("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>", opt)
map("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", opt)
map("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>", opt)
map("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", opt)
map("n", "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", opt)
map("n", "<Leader>B", "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opt)
map("n", "<Leader>lp", "<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opt)

map("n", "<Leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", opt)
map("n", "<Leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", opt)

-------------------- some record --------------------
return pluginKeys
