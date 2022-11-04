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
lua require("colorizer").setup()
lua require("plugin-config/indent")

"debug
lua require('dap-config')

" vim cmd for auto format when file saved
augroup FormatAutogroup
autocmd!
autocmd BufWritePost *.go,*.js,*.ts,*.rs,*.lua FormatWrite
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
"colorscheme monokai_pro
colorscheme dracula

" use F12 control floaterm
" let g:floaterm_keymap_toggle = '<F12>'

" for debug
nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
nnoremap <silent> <F10> <Cmd>lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> <Cmd>lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>
nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.repl.open()<CR>
nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>

" do not show current block under line
let g:indent_blankline_show_current_context_start = v:false
