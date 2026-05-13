local M = {}

function M.setup()
  require("filetypes.common").indent(2)
  vim.opt_local.list = true
end

return M
