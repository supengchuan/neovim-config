local api=vim.api
-- api.nvim_command [[colorscheme gruvbox]]
api.nvim_command [[colorscheme sonokai]]

local map = vim.api.nvim_set_keymap

-------------------- for leader map start -------------------- 

-- open outline
map('n', '<leader>o', ':AerialToggle<CR>', {silent = true, noremap = true})

-- buffuer line
map('n', '<leader>h', ':BufferLineCyclePrev<CR>', {silent = true, noremap = true})
map('n', '<leader>l', ':BufferLineCycleNext<CR>', {silent = true, noremap = true})
map('n', '<leader>p', ':BufferLinePick<CR>', {silent = true, noremap = true})
map('n', '<leader>c', ':BufferLinePickClose<CR>', {silent = true, noremap = true})

-- write
map('n', '<leader>w', ':w<CR>', {noremap=true})
map('n', '<leader>q', ':wq<CR>', {noremap=true})


-------------------- for leader map end -------------------- 




-------------------- for ctrl map start -------------------- 

-- open nerdtree
map('n', '<C-n>', ':NERDTree<CR>', {noremap=true})

-- use ctrl-hjkl move cursor between windows
map('n', '<C-h>', '<C-w>h', {noremap=true})
map('n', '<C-j>', '<C-w>j', {noremap=true})
map('n', '<C-k>', '<C-w>k', {noremap=true})
map('n', '<C-l>', '<C-w>l', {noremap=true})
-- show parameter hint
map('n', '<C-q>', '<cmd>lua vim.lsp.buf.hover()<CR>', {silent = true, noremap = true})
-- go to definition
map('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', {silent = true, noremap = true})

-------------------- for ctrl map end -------------------- 



-------------------- insert mode key map start -------------------- 
map('i', 'jj', '<ESC>', {noremap=true})
map('i', 'kk', '<ESC>', {noremap=true})
-------------------- insert mode key map start -------------------- 
