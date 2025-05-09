local M = {}

local helper = require("modules.goimpl.helper")
local ui = require("modules.goimpl.ui")

M.open = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local gopls = helper.get_gopls(bufnr)
  if not gopls then
    vim.notify("cannot get gopls client go implement", vim.log.levels.WARN)
    return
  end

  if not gopls then
    vim.notify("No gopls client found in the current buffer", vim.log.levels.WARN, { title = "go-impl" })
    return
  end
  coroutine.wrap(function()
    local co = coroutine.running()

    local current_struct_name = helper.get_struct_at_cursor()
    local default_value = current_struct_name and helper.predict_abbreviation(current_struct_name)
    ui.get_receiver(default_value, function(receiver)
      coroutine.resume(co, receiver)
    end)
    local receiver = coroutine.yield()

    print("receiver is: ", receiver)

    local lnum = helper.get_lnum(receiver)
    if not lnum then
      vim.notify("Invalid receiver provided", vim.log.levels.INFO, { title = "goimpl" })
      return
    end

    -- Interface
    ---@class InterfaceData
    ---@field package string
    ---@field path string
    ---@field line integer
    ---@field col integer

    ---@type InterfaceData?
    local interface_data = nil
    local fzf_lua = require("modules.goimpl.fzf_lua")
    fzf_lua.env()

    interface_data = fzf_lua.get_interface(co, bufnr, gopls)
    print(vim.inspect(interface_data))

    for _, key in pairs({ "package", "path", "line", "col" }) do
      if not interface_data or not interface_data[key] then
        vim.notify("Failed to get the interface data", vim.log.levels.WARN, { title = "goimpl" })
        return
      end
    end

    -- Generic Arguments
    local interface_declaration, interface_base_name, generic_parameter_list, generic_parameters =
      helper.parse_interface(interface_data.path, interface_data.line, interface_data.col)

    if not interface_declaration or not interface_base_name or not generic_parameters then
      vim.notify("Failed to parse the selected item", vim.log.levels.WARN, { title = "goimpl" })
      return
    end

    local generic_arguments = {}
    if generic_parameter_list then
      for _, generic_parameter in ipairs(generic_parameters) do
        ui.get_generic_argument({
          name = generic_parameter.name,
          type = generic_parameter.type,
          interface_declaration = interface_declaration,
          interface_base_name = interface_base_name,
          generic_parameter_list = generic_parameter_list,
        }, function(arg)
          coroutine.resume(co, arg)
        end)
        local arg = coroutine.yield()
        if not arg then
          vim.notify(
            "Failed to get the generic type: " .. generic_parameter.name,
            vim.log.levels.ERROR,
            { title = "go-impl" }
          )
          return
        end
        table.insert(generic_arguments, arg)
      end
    end

    -- Run impl
    local interface_name = interface_base_name
    if #generic_arguments > 0 then
      interface_name = string.format("%s[%s]", interface_base_name, table.concat(generic_arguments, ","))
    end
    helper.impl(receiver, interface_data.package, interface_name, lnum)
  end)()
end

return M
