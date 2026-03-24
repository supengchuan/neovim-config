local job = require("plenary.job")

local M = {}

-- Treesitter query definitions
-- These queries do the small amount of syntax understanding the module needs:
-- find the current struct under the cursor, locate a single interface
-- declaration, and enumerate all interface declarations in a file.
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

local ts_query_interface_list = vim.treesitter.query.parse(
  "go",
  [[
    (type_spec
      name: (type_identifier) @interface_name
      type_parameters: (type_parameter_list
        (type_parameter_declaration
          name: (identifier) @generic_name
          type: (type_constraint) @generic_type
        )
      )?
      type: (interface_type)
    ) @type_spec
  ]]
)

-- Small buffer/parser utilities
---@param buf integer
local function delete_buf(buf)
  if vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_delete(buf, { force = true })
  end
end

---Get the root node for the given position
---@param row integer 0-based row position
---@param col integer 0-based column position
---@param root_lang_tree vim.treesitter.LanguageTree
---@return TSNode? root
local function get_root_for_position(row, col, root_lang_tree)
  local lang_tree = root_lang_tree:language_for_range({ row, col, row, col })

  for _, tree in pairs(lang_tree:trees()) do
    local root = tree:root()
    if root and vim.treesitter.is_in_node_range(root, row, col) then
      return root
    end
  end

  return nil
end

---@return TSNode?
local function get_node_at_cursor()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1] - 1, cursor[2]
  local buf = vim.api.nvim_win_get_buf(0)
  local root_lang_tree = vim.treesitter.get_parser(buf, "go", { error = false })
  if not root_lang_tree then
    return nil
  end

  root_lang_tree:parse()

  local root = get_root_for_position(row, col, root_lang_tree)
  if not root then
    return nil
  end

  return root:named_descendant_for_range(row, col, row, col)
end

-- Environment/tool discovery
---Get the gopls client for the current buffer
---@param bufnr integer The buffer number
---@return vim.lsp.Client? client The gopls client
function M.get_gopls(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "gopls" })
  return clients and clients[1]
end

---@return boolean
function M.ensure_impl_available()
  if vim.fn.executable("impl") == 1 then
    return true
  end

  vim.notify("cannot find `impl` in PATH", vim.log.levels.ERROR, { title = "fzf-goimpl" })
  return false
end

---@param bufnr integer
function M.run_goimports(bufnr)
  local ok, conform = pcall(require, "conform")
  if not ok then
    vim.notify("conform.nvim is not available, skip goimports", vim.log.levels.WARN, { title = "fzf-goimpl" })
    return
  end

  conform.format({
    async = true,
    bufnr = bufnr,
    formatters = { "goimports" },
    lsp_format = "never",
  }, function(err)
    if err then
      vim.notify("goimports failed after impl insertion", vim.log.levels.WARN, { title = "fzf-goimpl" })
    end
  end)
end

-- Struct inspection helpers
---@return StructInfo?
function M.get_cursor_struct_info()
  local ts_node = get_node_at_cursor()
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

  -- The same query extracts both the struct name and any type parameters so
  -- receiver prediction can preserve generic declarations.
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
      -- CamelCase capitals become extra letters in the default receiver:
      -- `HTTPRequest` -> `hr`.
      abbreviation = abbreviation .. char
    end
  end
  local generic_parameters = M.format_type_parameter_name_list(struct_info.generic_name)
  return string.lower(abbreviation) .. " *" .. struct_name .. generic_parameters, struct_info.line_end + 1
end

-- Interface parsing for the selected symbol
---Fetch the generics options for the interface with given path, line and column
---@param path string The path of the file
---@param line integer The line number of the interface symbol
---@param col integer The column number of the interface symbol
---@return InterfaceData? interface_data The full interface declaration
function M.parse_interface(path, line, col)
  -- Convert to 0-based index for treesitter
  line, col = line - 1, col - 1

  local lines = vim.fn.readfile(path)
  if not lines or #lines == 0 then
    return nil
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("filetype", "go", { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- The selected interface can live outside the current buffer, so we parse a
  -- temporary scratch buffer instead of depending on the file being open.
  ---@type vim.treesitter.LanguageTree?
  local root_lang_tree = vim.treesitter.get_parser(buf, "go", { error = false })
  if not root_lang_tree then
    delete_buf(buf)
    return nil
  end

  ---@type table<integer, TSTree>?
  local ts_trees = root_lang_tree:parse()
  if not ts_trees then
    vim.notify("cannot parse the file: " .. path .. "with treesitter", vim.log.levels.WARN, { title = "fzf-goimpl" })
    delete_buf(buf)
    return nil
  end

  ---@type InterfaceData
  local result = {}

  -- First record the source file's real `package` name. This matters because
  -- the package identifier used in code generation may differ from the import
  -- path segment shown elsewhere in the catalog.
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

  -- Then climb from the selected position back to the surrounding
  -- `type_declaration` and extract the interface declaration details.
  local root = get_root_for_position(line, col, root_lang_tree)
  if not root then
    delete_buf(buf)
    return nil
  end

  local node = root:named_descendant_for_range(line, col, line, col)
  while node and node:type() ~= "type_declaration" do
    node = node:parent()
  end

  if not node then
    delete_buf(buf)
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

  delete_buf(buf)

  return result
end

-- Lightweight per-file indexing used by the package catalog
---@param path string
---@param package_item PackageItem
---@return InterfaceItem[]
function M.list_interfaces_in_file(path, package_item)
  local lines = vim.fn.readfile(path)
  if not lines or #lines == 0 then
    return {}
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("filetype", "go", { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local root_lang_tree = vim.treesitter.get_parser(buf, "go", { error = false })
  if not root_lang_tree then
    delete_buf(buf)
    return {}
  end

  local ts_trees = root_lang_tree:parse()
  if not ts_trees or not ts_trees[1] then
    delete_buf(buf)
    return {}
  end

  local root = ts_trees[1]:root()
  local interfaces = {}

  -- The catalog only needs a lightweight index here: interface name, package
  -- identity, and the source location needed for a later precise re-parse.
  for _, match in ts_query_interface_list:iter_matches(root, buf, 0, -1, { all = true }) do
    local item = {
      import_path = package_item.import_path,
      package_name = package_item.package_name,
      source_kind = package_item.source_kind,
      path = path,
      line = 0,
      col = 0,
      container_name = package_item.import_path,
    }

    local generic_parameters = {}

    for id, nodes in pairs(match) do
      local capture = ts_query_interface_list.captures[id]
      for _, node in pairs(nodes) do
        if capture == "interface_name" then
          item.name = vim.treesitter.get_node_text(node, buf)
        elseif capture == "generic_name" then
          generic_parameters[#generic_parameters + 1] = vim.treesitter.get_node_text(node, buf)
        elseif capture == "type_spec" then
          local row, col = node:range()
          item.line = row + 1
          item.col = col + 1
        end
      end
    end

    if #generic_parameters > 0 then
      item.generic_parameters = generic_parameters
    end

    if item.name and item.line > 0 then
      interfaces[#interfaces + 1] = item
    end
  end

  delete_buf(buf)
  return interfaces
end

-- Convert parsed interface metadata into the expression expected by `impl`
---@param target_dir string
---@param interface_item InterfaceItem
---@param interface_data InterfaceData
---@return string?
function M.build_interface_expr(target_dir, interface_item, interface_data)
  local interface_name = interface_data.name
  if not interface_name or interface_name == "" then
    return nil
  end

  if interface_data.generic_parameters then
    interface_name = interface_name .. M.format_type_parameter_name_list(interface_data.generic_parameters)
  end

  local interface_dir = vim.fs.dirname(interface_item.path)
  if interface_dir == target_dir then
    -- Same-package interfaces must stay unqualified for `impl`.
    return interface_name
  end

  -- Cross-package interfaces must be qualified so `impl` can generate method
  -- signatures in the target package context.
  local interface_package_name = interface_data.real_package_name or interface_item.package_name
  if not interface_package_name or interface_package_name == "" then
    return interface_name
  end

  return string.format("%s.%s", interface_package_name, interface_name)
end

-- External tool invocation and buffer insertion
---Run `impl`(https://github.com/josharian/impl) to add implementation for the given interface
---@param receiver string The receiver string
---@param target_dir string The package dir for the file being edited
---@param interface_expr string The interface expression passed to impl
---@param bufnr integer The buffer number to update
---@param lnum integer The line number to add the implementation
function M.impl(receiver, target_dir, interface_expr, bufnr, lnum)
  local lines = {}
  local stderr = {}

  local job_config = {
    command = "impl",
    cwd = target_dir,
    args = {
      "-dir",
      target_dir,
      receiver,
      interface_expr,
    },
    on_stdout = function(_, data)
      table.insert(lines, data)
    end,
    on_stderr = function(_, data)
      if data and data ~= "" then
        stderr[#stderr + 1] = data
      end
    end,
    on_exit = function(_, code)
      if code ~= 0 then
        vim.schedule(function()
          local message = "Failed to add the implementation"
          if #stderr > 0 then
            message = message .. ": " .. table.concat(stderr, "\n")
          end
          vim.notify(message, vim.log.levels.ERROR, { title = "fzf-goimpl" })
        end)
        return
      end

      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end

        -- `impl` returns raw text snippets. Trim the extra blank lines it tends
        -- to emit so insertion is stable regardless of the interface shape.
        -- before newline
        while #lines > 0 and lines[1] == "" do
          table.remove(lines, 1)
        end

        table.insert(lines, 1, "")

        -- after newline
        while #lines > 0 and lines[#lines] == "" do
          table.remove(lines, #lines)
        end

        vim.api.nvim_buf_set_lines(bufnr, lnum, lnum, false, lines)
        -- Let goimports own import management after the new methods land.
        M.run_goimports(bufnr)
      end)
    end,
  }
  print("[fzf-goimpl run] impl", table.concat(job_config.args, " "))

  job:new(job_config):start()
end

-- Shared formatting helpers
---@param type_parameter_names string[]
function M.format_type_parameter_name_list(type_parameter_names)
  if not type_parameter_names or #type_parameter_names == 0 then
    return ""
  end
  return "[" .. table.concat(type_parameter_names, ", ") .. "]"
end

return M
