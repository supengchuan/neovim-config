local M = {}

function M.setup_after()
  local ok, npairs = pcall(require, "nvim-autopairs")
  if not ok then
    vim.notify("nvim-autopairs not load for markdown, skip...", vim.log.levels.INFO)
    return
  end

  local rule = npairs.get_rule("[")
  if rule then
    rule.end_pair = ""
  end
end

return M
