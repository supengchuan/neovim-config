-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- silent = true 结果不会在command栏显示 为false会在command栏显示
local opts = { noremap = true, silent = true }

-- leader key "<space>"
vim.g.mapleader = " "

local map = vim.api.nvim_set_keymap

--  bufferline.nvim
map("n", "<leader>h", "<cmd>BufferLineCyclePrev<CR>", opts)
map("n", "<leader>l", "<cmd>BufferLineCycleNext<CR>", opts)
map("n", "<leader>p", "<cmd>BufferLinePick<CR>", opts)
map("n", "<leader>c", "<cmd>BufferLinePickClose<CR>", opts)

-- quick move
-- 取消 HL原本的映射, 作为快速移动的映射
map("n", "H", "", opts)
map("n", "H", "35h", opts)
map("n", "L", "", opts)
map("n", "L", "35l", opts)
map("n", "<leader>j", "5j", opts)
map("n", "<leader>k", "5k", opts)

-- write
-- save and exit
map("n", "<leader>w", "<cmd>w<CR>", opts)
map("n", "<leader>q", "<cmd>q<CR>", opts)
map("n", "<leader>nl", "<cmd>nohlsearch<CR>", opts)

-- open outline
map("n", "<leader>o", "<cmd>AerialToggle<CR>", opts)

-- resize
map("n", "<leader>=", "<cmd>vertical resize +10<CR>", opts)
map("n", "<leader>-", "<cmd>vertical resize -10<CR>", opts)

-- format
map("n", "<leader>f", "<cmd>Format<CR>", opts)

-- nvim-tree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", opts)

-- 窗口之间跳转
-- use ctrl-hjkl move cursor between windows
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- diagnostic
map("n", "<leader>i", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
map("n", "<leader>d[", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
map("n", "<leader>d]", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
map("n", "<leader>dd", "<cmd>Telescope diagnostics<CR>", opts)
map("n", "<C-q>", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)

-- show parameter hint
map("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
-- go to definition
map("n", "<C-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
--map("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
map("n", "gr", "<cmd>lua require('telescope.builtin').lsp_references({include_declaration = false})<CR>", opts)
map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

-- double j to normal mode
map("i", "jj", "<ESC>", { noremap = true })
-- no use
--map("i", "<Tab>", "vsnip#jumpable(1)?'<Plug>(vsnip-jump-next)':'<Tab>'", opt)

-- telescope
map("n", "<leader>e", "<cmd>Telescope buffers<CR>", opts)
map("n", "<leader>lg", "<cmd>lua require('telescope.builtin').live_grep({initial_mode = 'insert'})<cr>", opts)
map("n", "<leader>s", "<cmd>lua require('telescope.builtin').grep_string({initial_mode = 'insert'})<cr>", opts)

-- dap
map("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>", opts)
map("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", opts)
map("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>", opts)
map("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", opts)
map("n", "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
map("n", "<Leader>B", "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
map("n", "<Leader>lp", "<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opts)

map("n", "<Leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", opts)
map("n", "<Leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", opts)

map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", opts)
map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", opts)
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", opts)
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
