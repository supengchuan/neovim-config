local ok, npairs = pcall(require, "nvim-autopairs")
if not ok then
  vim.notify("nvim-autopairs not load for markdown, skip...", vim.log.levels.INFO)
  return
end

-- 获取已有的 `[` 规则
local rule = npairs.get_rule("[")
-- 不启用自动补全
rule.end_pair = ""
