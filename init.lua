--require("packer_plugins")
--require("pckr_plugins")
require("lazy_plugins")

require("basic")
require("keybindings")
require("format")

--cmp
require("cmp-config")
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

--latex
require("tex")

-- set bg transparent
vim.cmd([[highlight Normal ctermbg=NONE guibg=NONE guifg=NONE ]])
vim.cmd([[highlight NormalFloat ctermbg=NONE guibg=NONE]])
vim.cmd([[highlight SignColumn ctermbg=NONE guibg=NONE]])
vim.cmd([[highlight NvimTreeNormal guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight BufferLineFill guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight BufferLineBufferSelected guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight TelescopeNormal guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight Pmenu guibg=NONE]])
vim.cmd([[highlight CmpItemAbbrMatch guibg=NONE]])
vim.cmd([[highlight FloatShadow guibg=NONE]])
