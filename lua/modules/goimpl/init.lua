local M = {}

local helper = require("modules.goimpl.helper")
local ui = require("modules.goimpl.ui")

M.open = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local gopls = helper.get_gopls(bufnr)
  if not gopls then
    vim.notify("cannot get gopls client for go implement", vim.log.levels.WARN, { title = "fzf-goimpl" })
    return
  end

  coroutine.wrap(function()
    local co = coroutine.running()

    local struct_info = helper.get_cursor_struct_info()
    local default_value, line_num = helper.predict_abbreviation(struct_info)
    if not line_num then
      vim.notify("Invalid receiver provided", vim.log.levels.INFO, { title = "fzf-goimpl" })
      return
    end
    ui.get_receiver(default_value, function(receiver)
      coroutine.resume(co, receiver)
    end)
    local receiver = coroutine.yield()

    ---@type InterfaceItem?
    local interface_item = nil
    local fzf_lua = require("modules.goimpl.fzf_lua")
    -- init
    fzf_lua.init()

    interface_item = fzf_lua.get_interface(co, bufnr, gopls)
    --print("[Debug]: interface item from fzf_lua", vim.inspect(interface_item))

    for _, key in pairs({ "container_name", "path", "line", "col" }) do
      if not interface_item or not interface_item[key] then
        vim.notify("Failed to get the interface data", vim.log.levels.WARN, { title = "fzf-goimpl" })
        return
      end
    end

    -- Generic Arguments
    --print("[Debug]: ", "path: " .. interface_data.path, "line: " .. interface_data.line, "col: " .. interface_data.col)
    ---@type InterfaceData?
    local interface_data = helper.parse_interface(interface_item.path, interface_item.line, interface_item.col)
    if not interface_data or not interface_data.name then
      vim.notify("Failed to parse the selected interface item", vim.log.levels.WARN, { title = "fzf-goimpl" })
      return
    end

    ---@type string
    local interface_name = interface_data.name

    if interface_data.generic_parameters then
      interface_name =
        string.format("%s%s", interface_name, helper.format_type_parameter_name_list(interface_data.generic_parameters))
    end
    helper.impl(receiver, vim.fs.dirname(interface_item.path), interface_name, line_num)
  end)()
end

return M
