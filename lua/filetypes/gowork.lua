local M = {}

function M.setup()
  require("filetypes.go").setup({ kind = "gowork" })
end

return M
