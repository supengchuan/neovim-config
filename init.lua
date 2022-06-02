-- use space as the leader key
vim.g.mapleader=' '

vim.cmd[[set mouse=a]]
vim.o.hidden = true

-- needed by nvim-compe
vim.o.completeopt = "menuone,noselect"

vim.o.relativenumber=true
vim.o.tabstop=4
vim.o.shiftwidth=4
vim.o.smartcase=true
vim.o.scrolloff=25
vim.o.cursorline=true
vim.o.incsearch=true
vim.o.termguicolors=true
vim.o.clipboard = "unnamedplus"



require('plugins')


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

-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['gopls'].setup {
  capabilities = capabilities
}

