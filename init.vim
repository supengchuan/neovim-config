lua require("basic")
lua require("plugins")
lua require("keybindings")
lua require("format")

lua require("lsp/cmp")
"lua require("lsp/rust")

" config status line
lua require("lualine").setup()


lua require("plugin-config/gitsigns")
lua require("plugin-config/tree-sitter")
lua require("plugin-config/bufferline")

" vim cmd for auto format when file saved
augroup FormatAutogroup
autocmd!
autocmd BufWritePost *.js,*.jsx,*.ts,*.tsx,*.rs,*.lua FormatWrite
augroup END

" set create a new file with LR end line
set fileformats=unix,dos

" snip for jump to next parameter using tab
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
