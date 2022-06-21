lua require("basic")
lua require("plugins")
lua require("keybindings")
lua require("format")

lua require("lsp/cmp")
lua require("lsp/rust")
lua require("plugin-config/gitsigns")

" config status line
lua require("lualine").setup()



" vim cmd for auto format when file saved
augroup FormatAutogroup
autocmd!
autocmd BufWritePost *.js,*.jsx,*.ts,*.tsx,*.rs,*.lua FormatWrite
augroup END

" set create a new file with LR end line
set fileformats=unix,dos
