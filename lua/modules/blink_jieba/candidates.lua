local Candidates = {}
Candidates.__index = Candidates

local function is_cjk(codepoint)
  return (codepoint >= 0x3400 and codepoint <= 0x4DBF)
    or (codepoint >= 0x4E00 and codepoint <= 0x9FFF)
    or (codepoint >= 0xF900 and codepoint <= 0xFAFF)
    or (codepoint >= 0x20000 and codepoint <= 0x2FA1F)
end

local function has_cjk(text)
  for index = 0, vim.fn.strchars(text) - 1 do
    if is_cjk(vim.fn.strgetchar(text, index)) then
      return true
    end
  end
  return false
end

local function is_useful_token(token)
  if token == "" then
    return false
  end
  if has_cjk(token) then
    return vim.fn.strchars(token) > 1
  end
  return token:find("[%w_%-]") ~= nil
end

---@class BlinkJiebaCandidates
---@field cut fun(text: string): string[]
---@field token_cache table<string, string[]>
---@field cache_order string[]
---@field cache_next_slot integer
---@field max_cache_items integer

---@param cut fun(text: string): string[]
---@param max_cache_items? integer
---@return BlinkJiebaCandidates
function Candidates.new(cut, max_cache_items)
  return setmetatable({
    cut = cut,
    token_cache = {},
    cache_order = {},
    cache_next_slot = 1,
    max_cache_items = max_cache_items or 1000,
  }, Candidates)
end

---@param label string
---@return string[]
function Candidates:tokens_for_label(label)
  if self.token_cache[label] ~= nil then
    return self.token_cache[label]
  end

  local tokens = has_cjk(label) and self.cut(label) or { label }
  if self.max_cache_items <= 0 then
    return tokens
  end

  local evicted_label = self.cache_order[self.cache_next_slot]
  if evicted_label ~= nil then
    self.token_cache[evicted_label] = nil
  end
  self.cache_order[self.cache_next_slot] = label
  self.cache_next_slot = (self.cache_next_slot % self.max_cache_items) + 1
  self.token_cache[label] = tokens
  return tokens
end

local function longest_suffix_prefix(query, candidate)
  local character_count = vim.fn.strchars(query)
  for character_index = 0, character_count - 1 do
    local suffix = vim.fn.strcharpart(query, character_index)
    if vim.startswith(candidate, suffix) then
      return suffix
    end
  end
end

---@param context blink.cmp.Context
---@return boolean
function Candidates:is_query_dependent(context)
  local query = context.line:sub(context.bounds.start_col, context.cursor[2])
  return has_cjk(query)
end

---@param context blink.cmp.Context
---@param raw_items blink.cmp.CompletionItem[]
---@return blink.cmp.CompletionItem[]
function Candidates:build(context, raw_items)
  local query = context.line:sub(context.bounds.start_col, context.cursor[2])
  if query == "" then
    return {}
  end

  -- Keep Blink's native buffer behavior (and avoid initializing jieba) unless
  -- the current query actually contains Chinese text.
  if not self:is_query_dependent(context) then
    return raw_items
  end

  local row = context.cursor[1] - 1
  local seen = {}
  local items = {}

  for _, raw_item in ipairs(raw_items) do
    local label = raw_item.label or ""
    for _, token in ipairs(self:tokens_for_label(label)) do
      local tail = longest_suffix_prefix(query, token)
      if tail ~= nil and token ~= tail and not seen[token] and is_useful_token(token) then
        seen[token] = true
        local prefix = query:sub(1, #query - #tail)
        local replace_start = context.cursor[2] - #tail
        local item = vim.deepcopy(raw_item)
        item.label = token
        item.filterText = prefix .. token
        item.insertText = nil
        item.insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText
        item.textEdit = {
          newText = token,
          range = {
            start = { line = row, character = replace_start },
            ["end"] = { line = row, character = context.cursor[2] },
          },
        }
        table.insert(items, item)
      elseif tail == nil and not has_cjk(label) and not seen[label] then
        -- Let Blink's fuzzy matcher handle ordinary non-Chinese candidates.
        -- They normally disappear for a Chinese query, but keeping them here
        -- preserves the behavior of the native buffer source.
        seen[label] = true
        table.insert(items, raw_item)
      end
    end
  end

  return items
end

return Candidates
