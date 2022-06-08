local api=vim.api
-- api.nvim_command [[colorscheme gruvbox]]
api.nvim_command [[colorscheme sonokai]]

local map = vim.api.nvim_set_keymap

-- open nerdtree
map('n', '<leader>n', ':NERDTreeFocus<CR>', {noremap=true})
map('n', '<C-n>', ':NERDTree<CR>', {noremap=true})
-- use ctrl-hjkl move cursor between windows
map('n', '<C-h>', '<C-w>h', {noremap=true})
map('n', '<C-j>', '<C-w>j', {noremap=true})
map('n', '<C-k>', '<C-w>k', {noremap=true})
map('n', '<C-l>', '<C-w>l', {noremap=true})
-- write
map('n', '<leader>w', ':w<CR>', {noremap=true})
map('n', '<leader>q', ':wq<CR>', {noremap=true})

map('i', 'jj', '<ESC>', {noremap=true})
map('n', '<C-q>', '<cmd>lua vim.lsp.buf.hover()<CR>', {silent = true, noremap = true})


