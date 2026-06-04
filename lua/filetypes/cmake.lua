local M = {}

function M.setup()
  local common = require("filetypes.common")

  common.indent(4)
  common.text_width(100)
end

return M
