require("basic")
require("plugins")
require("keybindings")
require("format")

--lsp
require("lsp-config")

-- plugin-config
require("plugin-config")

-- debug
require("dap-config")

-- autocmd
require("autocmd")

-- colorscheme
require("colorscheme")

--vim.cmd([[
--	augroup FormatAutogroup
--		autocmd!
--		autocmd BufWritePost *.go,*.js,*.ts,*.rs,*.lua FormatWrite
--	augroup END
--]])
