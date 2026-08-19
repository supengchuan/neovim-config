local M = {}

local function is_table_separator(line)
  return line:match("^%s*|?%s*:?-+:?%s*|%s*:?-+:?") ~= nil
end

local function is_table_start(lines, index)
  return lines[index]:find("|", 1, true) ~= nil and lines[index + 1] ~= nil and is_table_separator(lines[index + 1])
end

local function list_prefix(line)
  return line:match("^(%s*[-+*]%s+)") or line:match("^(%s*%d+[.)]%s+)")
end

local function is_protected(line)
  return line:match("^%s*#")
    or line:match("^%s*>")
    or line:match("^%s*[-*_][-%s*_]+$")
end

local function tokenize(text)
  local tokens = {}
  local pending_space = false
  local index = 0
  local length = vim.fn.strchars(text)

  while index < length do
    local char = vim.fn.strcharpart(text, index, 1)
    if char:match("%s") then
      pending_space = true
      index = index + 1
    elseif #char == 1 and char:match("[A-Za-z0-9_@#%%+%-%./:=?&~]") then
      local word = char
      index = index + 1
      while index < length do
        local next_char = vim.fn.strcharpart(text, index, 1)
        if #next_char ~= 1 or not next_char:match("[A-Za-z0-9_@#%%+%-%./:=?&~]") then
          break
        end
        word = word .. next_char
        index = index + 1
      end
      table.insert(tokens, { text = word, space = pending_space })
      pending_space = false
    else
      table.insert(tokens, { text = char, space = pending_space })
      pending_space = false
      index = index + 1
    end
  end

  return tokens
end

local function reflow_block(output, text, width, prefix)
  local continuation_prefix = prefix and string.rep(" ", vim.fn.strdisplaywidth(prefix)) or ""
  local current = ""
  local first_line = true

  for _, token in ipairs(tokenize(text)) do
    local separator = current ~= "" and token.space and " " or ""
    local line_prefix = first_line and (prefix or "") or continuation_prefix
    local candidate = current .. separator .. token.text

    if current ~= "" and vim.fn.strdisplaywidth(line_prefix .. candidate) > width then
      table.insert(output, line_prefix .. current)
      current = token.text
      first_line = false
    else
      current = candidate
    end
  end

  if current ~= "" then
    local line_prefix = first_line and (prefix or "") or continuation_prefix
    table.insert(output, line_prefix .. current)
  end
end

function M.reflow_lines(lines, soft_width, hard_width)
  soft_width = soft_width or 85
  hard_width = hard_width or soft_width + 5
  local output = {}
  local index = 1
  local in_fence = false

  while index <= #lines do
    local line = lines[index]
    local fence = line:match("^%s*```") or line:match("^%s*~~~")

    if fence then
      in_fence = not in_fence
      table.insert(output, line)
      index = index + 1
    elseif in_fence or line:match("^%s*$") or is_protected(line) then
      table.insert(output, line)
      index = index + 1
    elseif is_table_start(lines, index) then
      repeat
        table.insert(output, lines[index])
        index = index + 1
      until index > #lines or lines[index]:match("^%s*$")
    else
      local prefix = list_prefix(line)
      local paragraph = { vim.trim(prefix and line:sub(#prefix + 1) or line) }
      index = index + 1

      while index <= #lines do
        local next_line = lines[index]
        if next_line:match("^%s*$")
          or next_line:match("^%s*```")
          or next_line:match("^%s*~~~")
          or is_protected(next_line)
          or is_table_start(lines, index)
          or list_prefix(next_line)
        then
          break
        end
        table.insert(paragraph, vim.trim(next_line))
        index = index + 1
      end

      reflow_block(output, table.concat(paragraph, " "), hard_width, prefix)
    end
  end

  return output
end

function M.reflow(soft_width, hard_width)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, M.reflow_lines(lines, soft_width, hard_width))
end

return M
