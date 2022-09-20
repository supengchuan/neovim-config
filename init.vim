lua require("basic")
lua require("plugins")
lua require("keybindings")
lua require("format")

lua require("lsp/cmp")
lua require("lsp/rust")
lua require("lsp/clangd")

lua require("plugin-config/gitsigns")
lua require("plugin-config/tree-sitter")
lua require("plugin-config/bufferline")
lua require("plugin-config/lualine-config")
lua require("plugin-config/nvim-tree")
lua require("plugin-config/aerial-config")
" lua require("plugin-config/ufo-config")

" vim cmd for auto format when file saved
augroup FormatAutogroup
autocmd!
autocmd BufWritePost *.go,*.js,*.jsx,*.ts,*.tsx,*.rs,*.lua FormatWrite
augroup END

" set create a new file with LR end line
set fileformats=unix,dos

" snip for jump to next parameter using tab
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif
"autocmd vimenter * ++nested colorscheme gruvbox
colorscheme monokai_pro
