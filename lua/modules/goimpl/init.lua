local M = {}

local helper = require("modules.goimpl.helper")
local ui = require("modules.goimpl.ui")

local function format_type_parameter_name_list(type_parameter_names)
  if #type_parameter_names == 0 then
    return ""
  end
  return "[" .. table.concat(type_parameter_names, ", ") .. "]"
end

M.open = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local gopls = helper.get_gopls(bufnr)
  if not gopls then
    vim.notify("cannot get gopls client for go implement", vim.log.levels.WARN, { title = "goimpl" })
    return
  end

  coroutine.wrap(function()
    local co = coroutine.running()

    local struct_name = helper.get_struct_at_cursor()
    local default_value = struct_name and helper.predict_abbreviation(struct_name)
    ui.get_receiver(default_value, function(receiver)
      coroutine.resume(co, receiver)
    end)
    local receiver = coroutine.yield()

    local line_num = helper.get_lnum(receiver)
    if not line_num then
      vim.notify("Invalid receiver provided", vim.log.levels.INFO, { title = "goimpl" })
      return
    end

    ---@type InterfaceItem?
    local interface_item = nil
    local fzf_lua = require("modules.goimpl.fzf_lua")
    -- init
    fzf_lua.init()

    interface_item = fzf_lua.get_interface(co, bufnr, gopls)
    print("[Debug]: interface item from fzf_lua", vim.inspect(interface_item))

    for _, key in pairs({ "package", "path", "line", "col" }) do
      if not interface_item or not interface_item[key] then
        vim.notify("Failed to get the interface data", vim.log.levels.WARN, { title = "goimpl" })
        return
      end
    end

    -- Generic Arguments
    --print("[Debug]: ", "path: " .. interface_data.path, "line: " .. interface_data.line, "col: " .. interface_data.col)
    local interface_declaration, interface_base_name, generic_parameter_list, generic_parameters =
      helper.parse_interface(interface_item.path, interface_item.line, interface_item.col)

    if not interface_declaration or not interface_base_name or not generic_parameters then
      vim.notify("Failed to parse the selected item", vim.log.levels.WARN, { title = "goimpl" })
      return
    end

    -- todo: solve generic_parameters
    local generic_arguments = {}
    if generic_parameter_list then
      for _, generic_parameter in ipairs(generic_parameters) do
        generic_arguments[#generic_arguments + 1] = generic_parameter.name
      end
    end

    -- Run impl
    local interface_name = interface_base_name
    if #generic_arguments > 0 then
      interface_name = string.format("%s%s", interface_base_name, format_type_parameter_name_list(generic_arguments))
    end
    helper.impl(receiver, vim.fs.dirname(interface_item.path), interface_name, line_num)
  end)()
end

return M
