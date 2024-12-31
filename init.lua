require("basic")
require("lazy_plugins")

require("diagnostics")

-- autocmd
require("autocmd")

vim.cmd.colorscheme(require("utils").GetColorshemeFromENV())
vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
if vim.g.neovide then
  require("neovide-conf")
end
