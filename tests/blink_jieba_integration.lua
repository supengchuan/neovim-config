local root = vim.fn.getcwd()
package.path = table.concat({
  root .. "/lua/?.lua",
  root .. "/lua/?/init.lua",
  package.path,
}, ";")

local function contains(items, expected)
  for _, item in ipairs(items) do
    if item == expected then
      return true
    end
  end
  return false
end

local function item_by_label(items, label)
  for _, item in ipairs(items) do
    if item.label == label then
      return item
    end
  end
end

local ok, err = xpcall(function()
  local spec = require("plugins.blinkcmp")
  local jieba_dependency
  for _, dependency in ipairs(spec.dependencies) do
    if type(dependency) == "table" and dependency[1] == "neo451/jieba-lua" then
      jieba_dependency = dependency
      break
    end
  end

  assert(jieba_dependency, "blink.cmp must declare the jieba-lua dependency")
  assert(jieba_dependency.tag == "0.0.1", "jieba-lua must use the stable pure-Lua tag")
  assert(jieba_dependency.build == false, "pure-Lua jieba must not trigger a luarocks build")
  assert(contains(spec.opts.sources.default, "jieba_buffer"), "custom buffer source is not enabled")
  assert(not contains(spec.opts.sources.default, "buffer"), "native buffer source would leak Chinese sentences")
  assert(spec.opts.sources.providers.jieba_buffer.async == true, "Chinese segmentation must stay asynchronous")
  assert(spec.opts.sources.providers.jieba_buffer.score_offset == -3, "custom source must preserve buffer ranking")

  vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/lazy/jieba-lua")

  local line = "我本意是想换"
  local response
  require("modules.blink_jieba.source")
    .new({
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
    :get_completions({
      line = line,
      cursor = { 1, #line },
      bounds = { start_col = 1, length = #line },
    }, function(value)
      response = value
    end)

  assert(response, "source did not return a completion response")
  for _, item in ipairs(response.items) do
    assert(item.label ~= "我本意是想换行它却会被补全到文档中", "raw Chinese sentence leaked")
  end
  local item = assert(item_by_label(response.items, "换行"), "jieba did not produce the expected 换行 candidate")
  assert(
    item.textEdit.range.start.character == #"我本意是想",
    "completed text before the current word was replaced"
  )

  vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/lazy/blink.cmp")
  require("blink.cmp.fuzzy").set_implementation("rust")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, {
    "我本意是想换行它却会被补全到文档中",
    line,
  })
  vim.api.nvim_win_set_cursor(0, { 2, #line })

  local native_items = {}
  require("modules.blink_jieba.source")
    .new({
      buffer = {
        use_cache = false,
        get_bufnrs = function()
          return { vim.api.nvim_get_current_buf() }
        end,
      },
    })
    :get_completions({
      line = line,
      cursor = { 2, #line },
      bounds = { start_col = 1, length = #line },
    }, function(value)
      vim.list_extend(native_items, value.items)
    end)

  local completed = vim.wait(2000, function()
    return item_by_label(native_items, "换行") ~= nil
  end)
  assert(completed, "Blink's native buffer parser did not feed the segmented source: " .. vim.inspect(native_items))
  assert(
    not item_by_label(native_items, "我本意是想换行它却会被补全到文档中"),
    "native buffer parser leaked a sentence"
  )

  local native_item = item_by_label(native_items, "换行")
  vim.lsp.util.apply_text_edits({ native_item.textEdit }, vim.api.nvim_get_current_buf(), "utf-8")
  assert(
    vim.api.nvim_buf_get_lines(0, 1, 2, false)[1] == "我本意是想换行",
    "completion edit produced the wrong line"
  )
  print("PASS real jieba and Blink buffer integration")
end, debug.traceback)

if not ok then
  io.stderr:write("FAIL real jieba integration\n" .. err .. "\n")
  os.exit(1)
end
