local M = {}

function M.setup()
  require("filetypes.go").setup({ kind = "gomod" })
end

return M
