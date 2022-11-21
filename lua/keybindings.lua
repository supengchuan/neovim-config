-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- silent = true 结果不会在command栏显示 为false会在command栏显示
local opt = { noremap = true, silent = true }

-- leader key "<space>"
vim.g.mapleader = " "

local map = vim.api.nvim_set_keymap

--  bufferline.nvim
map("n", "<leader>h", "<cmd>BufferLineCyclePrev<CR>", opt)
map("n", "<leader>l", "<cmd>BufferLineCycleNext<CR>", opt)
map("n", "<leader>p", "<cmd>BufferLinePick<CR>", opt)
map("n", "<leader>c", "<cmd>BufferLinePickClose<CR>", opt)

-- quick move
-- 取消 HL原本的映射, 作为快速移动的映射
map("n", "H", "", opt)
map("n", "H", "35h", opt)
map("n", "L", "", opt)
map("n", "L", "35l", opt)
map("n", "<leader>j", "10j", opt)
map("n", "<leader>k", "10k", opt)

-- write
-- save and exit
map("n", "<leader>w", "<cmd>w<CR>", opt)
map("n", "<leader>q", "<cmd>q<CR>", opt)
map("n", "<leader>nl", "<cmd>nohlsearch<CR>", opt)

-- open outline
map("n", "<leader>o", "<cmd>AerialToggle<CR>", opt)

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

-- diagnostic
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
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opt)

-- double j to normal mode
map("i", "jj", "<ESC>", { noremap = true })
-- no use
--map("i", "<Tab>", "vsnip#jumpable(1)?'<Plug>(vsnip-jump-next)':'<Tab>'", opt)

-- telescope
map("n", "<leader>e", "<cmd>Telescope buffers<CR>", opt)

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

map("n", "<leader>gr", "<cmd>Gitsigns resert_hunk<CR>", opt)
map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", opt)

-------------------- some record --------------------

local pluginKeys = {}
-- toggleterm
-- <leader>t 浮动
-- <C-t> close
pluginKeys.mapToggleTerm = function(toggleterm)
	vim.keymap.set("n", "<leader>t", toggleterm.toggle)
	vim.keymap.set("t", "<C-t>", toggleterm.toggle)
end
return pluginKeys
