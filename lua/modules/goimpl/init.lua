local M = {}

local catalog = require("modules.goimpl.catalog")
local helper = require("modules.goimpl.helper")
local ui = require("modules.goimpl.ui")

-- Command entrypoint: gather editor context, ask the user what to implement,
-- resolve the chosen interface, then delegate the actual stub generation.
M.open = function()
  -- The command is intentionally orchestrated as a short pipeline:
  --   1. infer the receiver from the current struct
  --   2. let the user choose an interface
  --   3. resolve the interface declaration from disk
  --   4. call `impl`, then let goimports clean up imports
  local bufnr = vim.api.nvim_get_current_buf()
  if not helper.ensure_impl_available() then
    return
  end

  local gopls = helper.get_gopls(bufnr)
  local root = catalog.get_root(bufnr)
  if not gopls and not root then
    vim.notify("cannot get gopls and cannot find go.work or go.mod for package fallback", vim.log.levels.WARN, {
      title = "fzf-goimpl",
    })
    return
  end

  coroutine.wrap(function()
    -- The UI pieces (`nui` input and `fzf-lua`) are callback-based, so this
    -- coroutine keeps the control flow readable without deeply nested callbacks.
    local co = coroutine.running()

    -- Resolve the directory of the file being edited. This is the package
    -- context `impl` should use when generating methods and imports.
    local target_path = vim.api.nvim_buf_get_name(bufnr)
    local target_dir = target_path ~= "" and vim.fs.dirname(target_path) or nil
    if not target_dir then
      vim.notify("cannot determine the current Go file directory", vim.log.levels.WARN, { title = "fzf-goimpl" })
      return
    end

    -- Infer a sensible default receiver from the struct under the cursor so
    -- the user usually only needs to press <CR>.
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
    if not receiver or receiver == "" then
      return
    end

    local fzf_lua = require("modules.goimpl.fzf_lua")
    fzf_lua.init()

    ---@type InterfaceItem?
    local interface_item = nil
    if gopls then
      -- Prefer workspace symbols first because they are fast and already know
      -- about the current project. If nothing matches, fall back to the local
      -- catalog that also includes stdlib and dependency packages.
      interface_item = fzf_lua.pick_workspace_interface(co, bufnr, gopls, root ~= nil)
      if interface_item and interface_item.kind == "fallback" then
        interface_item = fzf_lua.pick_catalog_interface(co, bufnr, gopls, interface_item.query or "")
      end
    else
      interface_item = fzf_lua.pick_catalog_interface(co, bufnr, gopls, "")
    end

    if not interface_item then
      return
    end

    -- At this point the picker has only chosen a location. We still need a
    -- full syntax-level parse of the interface declaration before calling impl.
    for _, key in pairs({ "path", "line", "col" }) do
      if not interface_item or not interface_item[key] then
        vim.notify("Failed to get the interface data", vim.log.levels.WARN, { title = "fzf-goimpl" })
        return
      end
    end

    ---@type InterfaceData?
    local interface_data = helper.parse_interface(interface_item.path, interface_item.line, interface_item.col)
    if not interface_data or not interface_data.name then
      vim.notify("Failed to parse the selected interface item", vim.log.levels.WARN, { title = "fzf-goimpl" })
      return
    end

    -- Build the exact interface expression `impl` expects in the target
    -- package, for example `Writer` or `io.Writer[T]`.
    local interface_expr = helper.build_interface_expr(target_dir, interface_item, interface_data)
    if not interface_expr then
      vim.notify("Failed to build the selected interface expression", vim.log.levels.WARN, { title = "fzf-goimpl" })
      return
    end

    -- The final step only inserts method stubs. Import cleanup is delegated to
    -- goimports inside helper.impl.
    helper.impl(receiver, target_dir, interface_expr, bufnr, line_num)
  end)()
end

return M
