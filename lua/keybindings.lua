local api=vim.api

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
map('n', '<leader>q', ':q<CR>', {noremap=true})
map('n', '<leader>nl', ':nohlsearch<CR>', {silent = true, noremap = true})

-- quick move
map('n', '<leader>j', '10j', {silent = true, noremap = true})
map('n', '<leader>k', '10k', {silent = true, noremap = true})

-- resize
map('n', '<leader>=', ':vertical resize +10<CR>', {silent = true, noremap = true})
map('n', '<leader>-', ':vertical resize -10<CR>', {silent = true, noremap = true})

-- float term
map('n', '<leader>f', ':FloatermNew<CR>', {silent = true, noremap = true})
-------------------- for leader map end -------------------- 




-------------------- for ctrl map start -------------------- 

-- open nerdtree
--map('n', '<C-n>', ':NERDTreeToggle<CR>', {noremap=true})
map('n', '<C-n>', ':NvimTreeToggle<CR>', {silent = true, noremap=true})

-- use ctrl-hjkl move cursor between windows
map('n', '<C-h>', '<C-w>h', {noremap=true})
map('n', '<C-j>', '<C-w>j', {noremap=true})
map('n', '<C-k>', '<C-w>k', {noremap=true})
map('n', '<C-l>', '<C-w>l', {noremap=true})
-- show parameter hint
map('n', '<C-q>', '<cmd>lua vim.lsp.buf.hover()<CR>', {silent = true, noremap = true})
map('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', {silent = true, noremap = true})
-- go to definition
map('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', {silent = true, noremap = true})
--map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', {silent = true, noremap = true})
map('n', 'gr', '<cmd>Telescope lsp_references<CR>', {silent = true, noremap = true})
map('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', {silent = true, noremap = true})

-------------------- for ctrl map end -------------------- 



-------------------- insert mode key map start -------------------- 
map('i', 'jj', '<ESC>', {noremap=true})
map('i', 'kk', '<ESC>', {noremap=true})
-------------------- insert mode key map start -------------------- 


-------------------- some record -------------------- 
-- zR unfold all function
-- zc fold code
-- za unfold code
