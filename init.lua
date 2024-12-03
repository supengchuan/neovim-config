require("basic")
require("lazy_plugins")

require("wk")

require("diagnostics")

-- debug
require("dap-config")

-- autocmd
require("autocmd")

-- set colorscheme at last
local function getColorshemeFromENV()
  local scheme = "tokyonight"
  local fromENV = os.getenv("NVIM_COLOR")
  if fromENV ~= nil then
    scheme = fromENV
  end

  return scheme
end

vim.cmd.colorscheme(getColorshemeFromENV())
vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
if vim.g.neovide then
  require("neovide-conf")
end
