local job = require("plenary.job")
local parsers = require("nvim-treesitter.parsers")
local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

local ts_query_struct = vim.treesitter.query.parse(
  "go",
  [[
    (type_declaration
      (type_spec
        name: (type_identifier) @struct_name
        type_parameters: (type_parameter_list
          (type_parameter_declaration
        	name: (identifier) @generic_name
            type: (type_constraint) @generic_type
          )
        )?
        type: (struct_type)
      )
    ) @struct_declaration
  ]]
)

local ts_query_interface = vim.treesitter.query.parse(
  "go",
  [[
    (type_spec
      name: (type_identifier) @interface_name
      type_parameters: (type_parameter_list
        (type_parameter_declaration
          name: (identifier) @generic_name
          type: (type_constraint) @generic_type
        )
      )? @parameter_list
      type: (interface_type)
    )
  ]]
)

---Get the gopls client for the current buffer
---@param bufnr integer The buffer number
---@return vim.lsp.Client? client The gopls client
function M.get_gopls(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "gopls" })
  return clients and clients[1]
end

---@return StructInfo?
function M.get_cursor_struct_info()
  local ts_node = ts_utils.get_node_at_cursor()
  while ts_node and ts_node:type() ~= "type_declaration" do
    ts_node = ts_node:parent()
  end

  if not ts_node then
    --print("[Debug] ts_node is nil when get_cursor_struct_info")
    vim.notify("cannot get treesitter node info", vim.log.levels.INFO, { title = "fzf-goimpl" })
    return nil
  end

  ---@type StructInfo?
  local result = {}

  local start_row, _, end_row = ts_node:range(false)
  result.line_start = start_row
  result.line_end = end_row

  ---@type string[]
  local generic_names = {}
  for id, capture_node in ts_query_struct:iter_captures(ts_node, 0) do
    local capture = ts_query_struct.captures[id]
    if capture == "struct_name" then
      result.name = vim.treesitter.get_node_text(capture_node, 0)
    elseif capture == "generic_name" then
      generic_names[#generic_names + 1] = vim.treesitter.get_node_text(capture_node, 0)
    end
  end

  if #generic_names > 0 then
    result.generic_name = generic_names
  end

  --print("[Debug] struct info", vim.inspect(result))
  return result
end

---Predict the abbreviation for the current struct
---@param struct_info? StructInfo The Go struct info
---@return string abbreviation The predicted abbreviation
---@return integer? lnum
function M.predict_abbreviation(struct_info)
  if not struct_info then
    return "", nil
  end

  local struct_name = struct_info.name
  if not struct_name then
    return "", nil
  end

  local abbreviation = ""
  abbreviation = abbreviation .. string.sub(struct_name, 1, 1)
  for i = 2, #struct_name do
    local char = string.sub(struct_name, i, i)
    if char == string.upper(char) and char ~= string.lower(char) then
      abbreviation = abbreviation .. char
    end
  end
  local generic_parameters = M.format_type_parameter_name_list(struct_info.generic_name)
  return string.lower(abbreviation) .. " *" .. struct_name .. generic_parameters, struct_info.line_end + 1
end

---Fetch the generics options for the interface with given path, line and column
---@param path string The path of the file
---@param line integer The line number of the interface symbol
---@param col integer The column number of the interface symbol
---@return InterfaceData? interface_data The full interface declaration
function M.parse_interface(path, line, col)
  -- Convert to 0-based index for treesitter
  line, col = line - 1, col - 1

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("filetype", "go", { buf = buf })

  local lines = vim.fn.readfile(path)
  if not lines or #lines == 0 then
    return nil
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  ---@type vim.treesitter.LanguageTree?
  local root_lang_tree = parsers.get_parser(buf)
  if not root_lang_tree then
    return nil
  end

  ---@type table<integer, TSTree>?
  local ts_trees = root_lang_tree:parse()
  if not ts_trees then
    vim.notify("cannot parse the file: " .. path .. "with treesitter", vim.log.levels.WARN, { title = "fzf-goimpl" })
    return nil
  end

  ---@type InterfaceData
  local result = {}

  -- get buffer real package name
  local rootNode = ts_trees[1]:root()
  for node in rootNode:iter_children() do
    if node:type() == "package_clause" then
      -- child(0) is package , child(1) is package_name
      local name_node = node:child(1)
      local real_package_name = vim.treesitter.get_node_text(name_node, buf)
      result.real_package_name = real_package_name
      break
    end
  end

  -- get interface info
  local root = ts_utils.get_root_for_position(line, col, root_lang_tree)
  if not root then
    return nil
  end

  local node = root:named_descendant_for_range(line, col, line, col)
  while node and node:type() ~= "type_declaration" do
    node = node:parent()
  end

  if not node then
    return nil
  end

  local interface_declaration = vim.treesitter.get_node_text(node, buf)
  result.declaration = interface_declaration

  ---@type string[]?
  local generic_parameters = {}

  for id, capture_node in ts_query_interface:iter_captures(node, buf) do
    local capture = ts_query_interface.captures[id]
    local text = vim.treesitter.get_node_text(capture_node, buf)

    if capture == "interface_name" then
      result.name = text
    elseif capture == "generic_name" then
      generic_parameters[#generic_parameters + 1] = text
    end
  end

  if #generic_parameters > 0 then
    result.generic_parameters = generic_parameters
  end

  vim.api.nvim_buf_delete(buf, { force = true })

  --print("[Debug] interface data after parser: ", vim.inspect(result))
  return result
end

---Run `impl`(https://github.com/josharian/impl) to add implementation for the given interface
---@param receiver string The receiver string
---@param interface_dir string The interface package dir
---@param interface_name string The interface name
---@param lnum integer The line number to add the implementation
function M.impl(receiver, interface_dir, interface_name, lnum)
  local lines = {}

  local job_config = {
    command = "impl",
    args = {
      "-dir",
      interface_dir,
      receiver,
      interface_name,
    },
    on_stdout = function(_, data)
      table.insert(lines, data)
    end,
    on_exit = function(_, code)
      if code ~= 0 then
        vim.notify("Failed to add the implementation", vim.log.levels.ERROR, { title = "fzf-goimpl" })
        return
      end

      vim.schedule(function()
        -- before newline
        while #lines > 0 and lines[1] == "" do
          table.remove(lines, 1)
        end

        table.insert(lines, 1, "")

        -- after newline
        while #lines > 0 and lines[#lines] == "" do
          table.remove(lines, #lines)
        end

        vim.fn.append(lnum, lines)
      end)
    end,
  }
  print("[fzf-goimpl run] impl", table.concat(job_config.args, " "))

  job:new(job_config):start()
end

---@param type_parameter_names string[]
function M.format_type_parameter_name_list(type_parameter_names)
  if not type_parameter_names or #type_parameter_names == 0 then
    return ""
  end
  return "[" .. table.concat(type_parameter_names, ", ") .. "]"
end

return M
