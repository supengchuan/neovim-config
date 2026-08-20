local M = {}

-- 该模块只重排普通段落；Markdown 表格、代码块等结构保持原样。
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
  return line:match("^%s*#") or line:match("^%s*>") or line:match("^%s*[-*_][-%s*_]+$")
end

-- 闭合标点不能出现在行首。必要时允许它略微超过硬宽度，保留在上一行末尾。
local closing_punctuation = {
  ["，"] = true,
  ["。"] = true,
  ["！"] = true,
  ["？"] = true,
  ["；"] = true,
  ["："] = true,
  ["、】【"] = true,
  ["）"] = true,
  ["】"] = true,
  ["》"] = true,
  ["”"] = true,
  ["’"] = true,
}

-- 将 `code`、``code`` 等行内代码解析为一个整体。
-- 返回值依次为：完整源码、结束字符下标、去掉反引号后的可见内容。
local function inline_code_token(text, index, length)
  local delimiter_length = 1
  while index + delimiter_length < length and vim.fn.strcharpart(text, index + delimiter_length, 1) == "`" do
    delimiter_length = delimiter_length + 1
  end

  local cursor = index + delimiter_length
  while cursor + delimiter_length <= length do
    local matched = true
    for offset = 0, delimiter_length - 1 do
      if vim.fn.strcharpart(text, cursor + offset, 1) ~= "`" then
        matched = false
        break
      end
    end
    if matched then
      local end_index = cursor + delimiter_length
      return vim.fn.strcharpart(text, index, end_index - index),
        end_index,
        vim.fn.strcharpart(text, index + delimiter_length, cursor - index - delimiter_length)
    end
    cursor = cursor + 1
  end
end

local function starts_with(text, index, delimiter)
  return vim.fn.strcharpart(text, index, vim.fn.strchars(delimiter)) == delimiter
end

local function emphasis_token(text, index, length)
  -- 转义后的星号或下划线是普通字符，不参与强调语法解析。
  if index > 0 and vim.fn.strcharpart(text, index - 1, 1) == "\\" then
    return
  end

  -- 优先匹配更长的分隔符，避免把 ***text*** 误识别为 **text** 加一个星号。
  for _, delimiter in ipairs({ "***", "___", "**", "__", "*", "_" }) do
    local delimiter_length = vim.fn.strchars(delimiter)
    if starts_with(text, index, delimiter) then
      local cursor = index + delimiter_length
      while cursor + delimiter_length <= length do
        if starts_with(text, cursor, delimiter) then
          local end_index = cursor + delimiter_length
          return vim.fn.strcharpart(text, index, end_index - index),
            end_index,
            vim.fn.strcharpart(text, index + delimiter_length, cursor - index - delimiter_length)
        end
        cursor = cursor + 1
      end
    end
  end
end

local tokenize

-- 递归计算强调内容的渲染宽度，使嵌套的加粗、斜体和行内代码也能忽略标记宽度。
local function rendered_width(text)
  local width = 0
  local has_content = false
  for _, token in ipairs(tokenize(text)) do
    if has_content and token.space then
      width = width + 1
    end
    width = width + token.width
    has_content = true
  end
  return width
end

-- token.text 是最终写回文件的 Markdown 源码；token.width 是渲染后的可见宽度。
-- 英文单词、URL、行内代码和强调内容作为整体 token，避免从标记或单词中间断开。
tokenize = function(text)
  local tokens = {}
  local pending_space = false
  local index = 0
  local length = vim.fn.strchars(text)

  while index < length do
    local char = vim.fn.strcharpart(text, index, 1)
    if char:match("%s") then
      pending_space = true
      index = index + 1
    elseif char == "`" then
      local code, end_index, content = inline_code_token(text, index, length)
      if code then
        table.insert(tokens, { text = code, width = vim.fn.strdisplaywidth(content), space = pending_space })
        pending_space = false
        index = end_index
      else
        table.insert(tokens, { text = char, width = vim.fn.strdisplaywidth(char), space = pending_space })
        pending_space = false
        index = index + 1
      end
    elseif char == "*" or char == "_" then
      local emphasis, end_index, content = emphasis_token(text, index, length)
      if emphasis then
        table.insert(tokens, { text = emphasis, width = rendered_width(content), space = pending_space })
        pending_space = false
        index = end_index
      else
        table.insert(tokens, { text = char, width = vim.fn.strdisplaywidth(char), space = pending_space })
        pending_space = false
        index = index + 1
      end
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
      table.insert(tokens, { text = word, width = vim.fn.strdisplaywidth(word), space = pending_space })
      pending_space = false
    else
      table.insert(tokens, { text = char, width = vim.fn.strdisplaywidth(char), space = pending_space })
      pending_space = false
      index = index + 1
    end
  end

  return tokens
end

local function reflow_block(output, text, width, prefix)
  -- 列表续行使用与列表标记等宽的空格，保证正文起始位置对齐。
  local continuation_prefix = prefix and string.rep(" ", vim.fn.strdisplaywidth(prefix)) or ""
  local current = ""
  local current_width = 0
  local first_line = true

  for _, token in ipairs(tokenize(text)) do
    local separator = current ~= "" and token.space and " " or ""
    -- 中文闭合标点前不保留空格，也不因超过硬宽度而单独换到下一行。
    if closing_punctuation[token.text] then
      separator = ""
    end
    local line_prefix = first_line and (prefix or "") or continuation_prefix
    local candidate = current .. separator .. token.text
    local candidate_width = vim.fn.strdisplaywidth(line_prefix)
      + current_width
      + vim.fn.strdisplaywidth(separator)
      + token.width

    if current ~= "" and not closing_punctuation[token.text] and candidate_width > width then
      table.insert(output, line_prefix .. current)
      current = token.text
      current_width = token.width
      first_line = false
    else
      current = candidate
      current_width = current_width + vim.fn.strdisplaywidth(separator) + token.width
    end
  end

  if current ~= "" then
    local line_prefix = first_line and (prefix or "") or continuation_prefix
    table.insert(output, line_prefix .. current)
  end
end

function M.reflow_lines(lines, soft_width, hard_width)
  -- soft_width 是期望宽度，目前用于推导默认硬上限；真正触发换行的是 hard_width。
  soft_width = soft_width or 85
  hard_width = hard_width or soft_width + 5
  local output = {}
  local index = 1
  local in_fence = false

  while index <= #lines do
    local line = lines[index]
    local fence = line:match("^%s*```") or line:match("^%s*~~~")

    if fence then
      -- 围栏代码块从起止标记到内容全部原样保留。
      in_fence = not in_fence
      table.insert(output, line)
      index = index + 1
    elseif in_fence or line:match("^%s*$") or is_protected(line) then
      table.insert(output, line)
      index = index + 1
    elseif is_table_start(lines, index) then
      -- 表格由 Prettier 负责对齐，本模块不拆分任何表格行。
      repeat
        table.insert(output, lines[index])
        index = index + 1
      until index > #lines or lines[index]:match("^%s*$")
    else
      -- 合并同一普通段落的已有物理换行，再按渲染宽度统一重排。
      local prefix = list_prefix(line)
      local paragraph = { vim.trim(prefix and line:sub(#prefix + 1) or line) }
      index = index + 1

      while index <= #lines do
        local next_line = lines[index]
        if
          next_line:match("^%s*$")
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
  -- 保留直接操作当前 buffer 的入口；Conform 使用上面的纯函数 reflow_lines。
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, M.reflow_lines(lines, soft_width, hard_width))
end

return M
