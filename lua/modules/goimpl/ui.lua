local nui_input = require("nui.input")
local nui_layout = require("nui.layout")
local nui_line = require("nui.line")
local nui_popup = require("nui.popup")
local nui_text = require("nui.text")
local nui_event = require("nui.utils.autocmd").event

local M = {}

function M.get_receiver(default_value, callback)
  local nui_opts = {
    relative = "cursor",
    position = { row = 1, col = 0 },
    size = 40,
    border = { style = "rounded", text = { top_align = "center" } },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:GoImplGoBlue,FloatTitle:GoImplGoBlue",
    },
  }

  local input = nui_input(nui_opts, {
    prompt = nui_text(" 󰆼  > ", "Title"),
    default_value = default_value,
    on_close = callback,
    on_submit = callback,
    on_change = function() end,
  })

  input:mount()
  for _, event in ipairs({
    nui_event.BufWinLeave,
    nui_event.BufLeave,
    nui_event.InsertLeavePre,
  }) do
    input:on(event, function()
      input:unmount()
    end)
  end
end
return M
