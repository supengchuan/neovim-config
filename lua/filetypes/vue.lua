local M = {}

function M.setup()
  require("filetypes.common").indent(2)

  local ok, luasnip = pcall(require, "luasnip")
  if ok then
    luasnip.filetype_extend("vue", { "html" })
  end
end

return M
