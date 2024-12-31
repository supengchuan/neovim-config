require("basic")
require("lazy_plugins")

require("diagnostics")

-- debug
require("dap-config")

-- autocmd
require("autocmd")

vim.cmd.colorscheme(require("utils").getColorshemeFromENV())
vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
if vim.g.neovide then
  require("neovide-conf")
end
