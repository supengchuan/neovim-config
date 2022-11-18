local api = vim.api

local map = vim.api.nvim_set_keymap

-------------------- for leader map start --------------------

-- open outline
map("n", "<leader>o", ":AerialToggle<CR>", { silent = true, noremap = true })

-- buffuer line
map("n", "<leader>h", ":BufferLineCyclePrev<CR>", { silent = true, noremap = true })
map("n", "<leader>l", ":BufferLineCycleNext<CR>", { silent = true, noremap = true })
map("n", "<leader>p", ":BufferLinePick<CR>", { silent = true, noremap = true })
map("n", "<leader>c", ":BufferLinePickClose<CR>", { silent = true, noremap = true })

-- write
map("n", "<leader>w", ":w<CR>", { noremap = true })
map("n", "<leader>q", ":q<CR>", { noremap = true })
map("n", "<leader>nl", ":nohlsearch<CR>", { silent = true, noremap = true })

-- quick move
map("n", "<leader>j", "10j", { silent = true, noremap = true })
map("n", "<leader>k", "10k", { silent = true, noremap = true })

-- resize
map("n", "<leader>=", ":vertical resize +10<CR>", { silent = true, noremap = true })
map("n", "<leader>-", ":vertical resize -10<CR>", { silent = true, noremap = true })

-- format
map("n", "<leader>f", ":Format<CR>", { noremap = true, silent = true })

map("n", "<leader>t", ":FloatermToggle<CR>", { noremap = true, silent = true })
map("t", "<C-t>", "<C-\\><C-n>:FloatermToggle<CR>", { noremap = true, silent = true })
-------------------- for leader map end --------------------

-------------------- for ctrl map start --------------------

-- open nerdtree
--map('n', '<C-n>', ':NERDTreeToggle<CR>', {noremap=true})
map("n", "<C-n>", ":NvimTreeToggle<CR>", { silent = true, noremap = true })

-- use ctrl-hjkl move cursor between windows
map("n", "<C-h>", "<C-w>h", { noremap = true })
map("n", "<C-j>", "<C-w>j", { noremap = true })
map("n", "<C-k>", "<C-w>k", { noremap = true })
map("n", "<C-l>", "<C-w>l", { noremap = true })
-- show parameter hint
map("n", "<C-q>", "<cmd>lua vim.lsp.buf.hover()<CR>", { silent = true, noremap = true })
map("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", { silent = true, noremap = true })
-- go to definition
map("n", "<C-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", { silent = true, noremap = true })
--map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', {silent = true, noremap = true})
map("n", "gr", "<cmd>Telescope lsp_references<CR>", { silent = true, noremap = true })
map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { silent = true, noremap = true })

-- wrap virtual text
--vim.diagnostic.open_float()
map("n", "<leader>v", "<cmd>lua vim.diagnostic.open_float()<CR>", { silent = true, noremap = true })
-------------------- for ctrl map end --------------------

-------------------- insert mode key map start --------------------
map("i", "jj", "<ESC>", { noremap = true })
map("i", "<Tab>", "vsnip#jumpable(1)?'<Plug>(vsnip-jump-next)':'<Tab>'", { expr = true, noremap = true })

-------------------- insert mode key map start --------------------

-- buffuer select
map("n", "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", { silent = true, noremap = true })
map("n", "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", { silent = true, noremap = true })
map("n", "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", { silent = true, noremap = true })
map("n", "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", { silent = true, noremap = true })
map("n", "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", { silent = true, noremap = true })
map("n", "<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>", { silent = true, noremap = true })
map("n", "<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>", { silent = true, noremap = true })
map("n", "<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>", { silent = true, noremap = true })
map("n", "<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>", { silent = true, noremap = true })

-- dap
map("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>", { silent = true, noremap = true })
map("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", { silent = true, noremap = true })
map("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>", { silent = true, noremap = true })
map("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", { silent = true, noremap = true })
map("n", "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", { silent = true, noremap = true })
map(
	"n",
	"<Leader>B",
	"<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
	{ silent = true, noremap = true }
)
map(
	"n",
	"<Leader>lp",
	"<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
	{ silent = true, noremap = true }
)
map("n", "<Leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", { silent = true, noremap = true })
map("n", "<Leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", { silent = true, noremap = true })

-------------------- some record --------------------
