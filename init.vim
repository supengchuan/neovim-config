lua require("basic")
lua require("plugins")
lua require("keybindings")

lua require("lsp/cmp")
lua require("lsp/rust")
lua require("plugin-config/gitsigns")

" config status line
lua require("lualine").setup()
