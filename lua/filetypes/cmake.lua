local M = {}

function M.setup()
  local common = require("filetypes.common")

  common.indent(2)
  common.text_width(100)
end

return M
