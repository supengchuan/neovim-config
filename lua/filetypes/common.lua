local M = {}

function M.indent(width)
  vim.bo.tabstop = width
  vim.bo.shiftwidth = width
  vim.bo.softtabstop = width
  vim.bo.expandtab = true
end

function M.tab_indent(width)
  vim.bo.tabstop = width
  vim.bo.shiftwidth = width
  vim.bo.softtabstop = 0
  vim.bo.expandtab = false
end

function M.text_width(width)
  vim.bo.textwidth = width
  vim.opt_local.colorcolumn = tostring(width)
end

return M
