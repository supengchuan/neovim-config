local Candidates = require("modules.blink_jieba.candidates")

local Source = {}
Source.__index = Source

local function cut_with_jieba(text)
  return require("jieba.core").lcut(text, false, true)
end

function Source.new(opts)
  opts = opts or {}

  return setmetatable({
    buffer = opts.buffer_source or require("blink.cmp.sources.buffer").new(opts.buffer or {}),
    candidates = Candidates.new(opts.cut or cut_with_jieba, opts.cache_size),
    schedule = opts.schedule or vim.schedule,
    batch_size = opts.batch_size or 20,
  }, Source)
end

function Source:enabled()
  return self.buffer.enabled == nil or self.buffer:enabled()
end

function Source:get_completions(context, callback)
  local cancelled = false
  local upstream_cancel
  local query_dependent = self.candidates:is_query_dependent(context)

  upstream_cancel = self.buffer:get_completions(context, function(response)
    if cancelled then
      return
    end

    local raw_items = response.items or {}
    local index = 1
    local seen = {}

    local function emit_batch()
      if cancelled then
        return
      end

      local last = math.min(index + self.batch_size - 1, #raw_items)
      local batch = {}
      for item_index = index, last do
        table.insert(batch, raw_items[item_index])
      end

      local items = {}
      for _, item in ipairs(self.candidates:build(context, batch)) do
        if not seen[item.label] then
          seen[item.label] = true
          table.insert(items, item)
        end
      end

      index = last + 1
      callback({
        items = items,
        is_incomplete_forward = query_dependent or response.is_incomplete_forward or false,
        is_incomplete_backward = query_dependent or response.is_incomplete_backward or false,
      })

      if index <= #raw_items then
        self.schedule(emit_batch)
      end
    end

    self.schedule(emit_batch)
  end)

  return function()
    cancelled = true
    if upstream_cancel then
      upstream_cancel()
    end
  end
end

return Source
