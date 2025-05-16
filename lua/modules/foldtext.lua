---@modules foldtext
---based on  https://www.reddit.com/r/neovim/comments/16xz3q9/treesitter_highlighted_folds_are_now_in_neovim/ for highlights
---and: https://github.com/Wansmer/nvim-config/blob/main/lua/modules/foldtext.lua for file structure

function HighlightedFoldtext()
  -- resolve unknown filetype buffers
  local ft = vim.bo.filetype
  if ft == nil or ft == "" then
    return vim.fn.foldtext()
  end

  local pos = vim.v.foldstart
  local line = vim.api.nvim_buf_get_lines(0, pos - 1, pos, false)[1]
  local lang = vim.treesitter.language.get_lang(ft)
  local parser = vim.treesitter.get_parser(0, lang)
  local query = vim.treesitter.query.get(parser:lang(), "highlights")

  if query == nil then
    return vim.fn.foldtext()
  end

  local tree = parser:parse({ pos - 1, pos })[1]
  local result = {}

  local line_pos = 0

  local prev_range = nil

  for id, node, _ in query:iter_captures(tree:root(), 0, pos - 1, pos) do
    local name = query.captures[id]
    local start_row, start_col, end_row, end_col = node:range()
    if start_row == pos - 1 and end_row == pos - 1 then
      local range = { start_col, end_col }
      if start_col > line_pos then
        table.insert(result, { line:sub(line_pos + 1, start_col), "Folded" })
      end
      line_pos = end_col
      local text = vim.treesitter.get_node_text(node, 0)
      if prev_range ~= nil and range[1] == prev_range[1] and range[2] == prev_range[2] then
        result[#result] = { text, "@" .. name }
      else
        table.insert(result, { text, "@" .. name })
      end
      prev_range = range
    end
  end

  return result
end

---@param hl vim.api.keyset.get_hl_info
---@return vim.api.keyset.highlight
local function sanitize_hl(hl)
  local allowed_keys = {
    "fg",
    "bg",
    "sp",
    "bold",
    "italic",
    "underline",
    "undercurl",
    "reverse",
    "strikethrough",
    "nocombine",
    "link",
    "default",
    "ctermfg",
    "ctermbg",
  }
  local sanitized = {}
  for _, key in ipairs(allowed_keys) do
    if hl[key] ~= nil then
      sanitized[key] = hl[key]
    end
  end
  return sanitized
end

local bg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg
local hl = vim.api.nvim_get_hl(0, { name = "Folded" })
hl.bg = bg
vim.api.nvim_set_hl(0, "Folded", sanitize_hl(hl))

return 'luaeval("HighlightedFoldtext")()'
