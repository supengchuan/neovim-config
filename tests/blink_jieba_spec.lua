local root = vim.fn.getcwd()
package.path = table.concat({
  root .. "/lua/?.lua",
  root .. "/lua/?/init.lua",
  package.path,
}, ";")

local failures = 0

local function test(name, fn)
  local ok, err = xpcall(fn, debug.traceback)
  if ok then
    print("PASS " .. name)
    return
  end

  failures = failures + 1
  io.stderr:write("FAIL " .. name .. "\n" .. err .. "\n")
end

local function assert_equal(expected, actual, message)
  if vim.deep_equal(expected, actual) then
    return
  end

  error((message or "values differ") .. "\nexpected: " .. vim.inspect(expected) .. "\nactual: " .. vim.inspect(actual))
end

local function item_by_label(items, label)
  for _, item in ipairs(items) do
    if item.label == label then
      return item
    end
  end
end

local function fake_cut(text)
  local cuts = {
    ["我本意是想换"] = { "我", "本意", "是", "想", "换" },
    ["我本意是想换行它却会被补全到文档中"] = {
      "我",
      "本意",
      "是",
      "想",
      "换行",
      "它",
      "却",
      "会",
      "被",
      "补全",
      "到",
      "文档",
      "中",
    },
    ["markdown"] = { "markdown" },
    -- jieba 0.0.1 treats this unfinished phrase as one word. The completion
    -- range therefore cannot be derived from segmenting the query itself.
    ["想换"] = { "想换" },
  }
  return cuts[text] or { text }
end

test("segments buffer sentences and replaces only the unfinished Chinese word", function()
  local candidates = require("modules.blink_jieba.candidates").new(fake_cut)
  local line = "我本意是想换"
  local items = candidates:build({
    line = line,
    cursor = { 1, #line },
    bounds = { start_col = 1, length = #line },
  }, {
    { label = "我本意是想换行它却会被补全到文档中" },
    { label = "markdown" },
  })

  assert_equal(nil, item_by_label(items, "我本意是想换行它却会被补全到文档中"), "raw sentence leaked")

  local item = assert(item_by_label(items, "换行"), "missing segmented candidate")
  assert_equal("我本意是想换行", item.filterText)
  assert_equal({
    newText = "换行",
    range = {
      start = { line = 0, character = #"我本意是想" },
      ["end"] = { line = 0, character = #line },
    },
  }, item.textEdit)

  assert(item_by_label(items, "markdown"), "ASCII buffer candidate should be preserved")
  assert_equal(nil, item_by_label(items, "换"), "current incomplete word should not suggest itself")
  assert_equal(nil, item_by_label(items, "我"), "single-character Chinese candidates should be omitted")
end)

test("respects keyword bounds after Chinese punctuation", function()
  local candidates = require("modules.blink_jieba.candidates").new(fake_cut)
  local line = "说明，想换"
  local items = candidates:build({
    line = line,
    cursor = { 1, #line },
    bounds = { start_col = #"说明，" + 1, length = #"想换" },
  }, {
    { label = "我本意是想换行它却会被补全到文档中" },
  })

  local item = assert(item_by_label(items, "换行"), "missing segmented candidate")
  assert_equal("想换行", item.filterText)
  assert_equal(#"说明，想", item.textEdit.range.start.character)
  assert_equal(#line, item.textEdit.range["end"].character)
end)

test("caches segmentation by raw buffer label", function()
  local calls = 0
  local candidates = require("modules.blink_jieba.candidates").new(function(text)
    calls = calls + 1
    return fake_cut(text)
  end)
  local line = "我本意是想换"
  local context = {
    line = line,
    cursor = { 1, #line },
    bounds = { start_col = 1, length = #line },
  }
  local raw_items = { { label = "我本意是想换行它却会被补全到文档中" } }

  candidates:build(context, raw_items)
  local calls_after_first_build = calls
  candidates:build(context, raw_items)

  assert_equal(1, calls_after_first_build, "only the raw label should be segmented")
  assert_equal(1, calls, "the raw label segmentation should be reused")
end)

test("bounds the segmentation cache", function()
  local calls = 0
  local candidates = require("modules.blink_jieba.candidates").new(function(text)
    calls = calls + 1
    return { text }
  end, 2)

  candidates:tokens_for_label("中文甲")
  candidates:tokens_for_label("中文乙")
  candidates:tokens_for_label("中文丙")
  candidates:tokens_for_label("中文甲")

  assert_equal(4, calls, "the oldest segmentation should be evicted")
end)

test("does not initialize jieba for ASCII-only completion", function()
  local calls = 0
  local candidates = require("modules.blink_jieba.candidates").new(function(text)
    calls = calls + 1
    return { text }
  end)
  local line = "mar"

  candidates:build({
    line = line,
    cursor = { 1, #line },
    bounds = { start_col = 1, length = #line },
  }, {
    { label = "markdown" },
  })

  assert_equal(0, calls, "ASCII completion should not load the Chinese segmenter")
end)

test("asks Blink to refetch candidates as a Chinese query changes", function()
  local response
  local source = require("modules.blink_jieba.source").new({
    cut = fake_cut,
    schedule = function(fn)
      fn()
    end,
    buffer_source = {
      get_completions = function(_, _, callback)
        callback({
          items = { { label = "我本意是想换行它却会被补全到文档中" } },
          is_incomplete_forward = false,
          is_incomplete_backward = false,
        })
      end,
    },
  })

  source:get_completions({
    line = "我",
    cursor = { 1, #"我" },
    bounds = { start_col = 1, length = #"我" },
  }, function(value)
    response = value
  end)

  assert(response, "source did not return a completion response")
  assert_equal(true, response.is_incomplete_forward, "Blink would reuse the empty result after another character")
  assert_equal(true, response.is_incomplete_backward, "Blink would reuse candidates after deleting a character")
end)

test("streams segmented buffer candidates in scheduled batches", function()
  local scheduled = {}
  local source = require("modules.blink_jieba.source").new({
    batch_size = 1,
    cut = fake_cut,
    schedule = function(fn)
      table.insert(scheduled, fn)
    end,
    buffer_source = {
      get_completions = function(_, _, callback)
        callback({
          items = {
            { label = "markdown" },
            { label = "我本意是想换行它却会被补全到文档中" },
          },
          is_incomplete_forward = false,
          is_incomplete_backward = false,
        })
      end,
    },
  })
  local line = "我本意是想换"
  local responses = {}

  source:get_completions({
    line = line,
    cursor = { 1, #line },
    bounds = { start_col = 1, length = #line },
  }, function(response)
    table.insert(responses, response)
  end)

  assert_equal(0, #responses, "completion work should be deferred")
  assert_equal(1, #scheduled)

  table.remove(scheduled, 1)()
  assert_equal(1, #responses)
  assert(item_by_label(responses[1].items, "markdown"), "first batch should preserve ASCII candidates")
  assert_equal(1, #scheduled, "second batch should be scheduled separately")

  table.remove(scheduled, 1)()
  assert_equal(2, #responses)
  assert(item_by_label(responses[2].items, "换行"), "second batch should contain segmented Chinese candidates")
end)

test("cancels scheduled and upstream completion work", function()
  local scheduled = {}
  local upstream_cancelled = false
  local source = require("modules.blink_jieba.source").new({
    cut = fake_cut,
    schedule = function(fn)
      table.insert(scheduled, fn)
    end,
    buffer_source = {
      get_completions = function(_, _, callback)
        callback({
          items = { { label = "我本意是想换行它却会被补全到文档中" } },
          is_incomplete_forward = false,
          is_incomplete_backward = false,
        })
        return function()
          upstream_cancelled = true
        end
      end,
    },
  })
  local line = "我本意是想换"
  local responses = 0

  local cancel = source:get_completions({
    line = line,
    cursor = { 1, #line },
    bounds = { start_col = 1, length = #line },
  }, function()
    responses = responses + 1
  end)
  cancel()
  table.remove(scheduled, 1)()

  assert_equal(true, upstream_cancelled)
  assert_equal(0, responses)
end)

if failures > 0 then
  os.exit(1)
end
