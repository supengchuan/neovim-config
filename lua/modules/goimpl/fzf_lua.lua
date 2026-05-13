local catalog = require("modules.goimpl.catalog")

local M = {}

-- Lazy fzf-lua bootstrap. The picker code touches several internal helpers, so
-- they are cached on first use rather than required on every keystroke.
function M.init()
  if M.env_initiated then
    return
  end
  M.env_initiated = true
  M.core = require("fzf-lua")
  M.defaults = require("fzf-lua.defaults")
  M.make_entry = require("fzf-lua.make_entry")
  M.previewer_builtin = require("fzf-lua.previewer.builtin")
  M.utils = require("fzf-lua.utils")
  M.path = require("fzf-lua.path")
end

-- Rendering helpers
---@param text string
---@param highlight string
---@return string
local function with_hl(text, highlight)
  local styled = M.utils.ansi_from_hl(highlight, text)
  return styled or text
end

---@param query string
---@return string
local function format_fallback_line(query)
  local icon = with_hl("󰰐 ", "Comment")
  local label = string.format('Search packages/dependencies for "%s"', query)
  return icon .. with_hl(label, "Title")
end

---@param type_parameter_names string[]?
---@return string
local function format_type_parameters(type_parameter_names)
  if not type_parameter_names or #type_parameter_names == 0 then
    return ""
  end
  return "[" .. table.concat(type_parameter_names, ", ") .. "]"
end

---Convert the gopls result to a line
---@param item any gopls result
---@param query string the query string
---@return string? line the line to be displayed in the fzf window
local function to_workspace_line(item, query)
  local sym, text = item.text:match("^(.+%])(.*)$")
  if not sym or not text then
    return nil
  end

  local pattern = "["
    .. M.utils.lua_regex_escape(string.gsub(query, "%a", function(x)
      return string.upper(x) .. string.lower(x)
    end))
    .. "]+"

  item.text = sym
    .. text:gsub(pattern, function(x)
      return M.utils.ansi_codes["Title"](x)
    end)

  local styled = with_hl("󰰄 ", "Comment")
  item.text = item.text:gsub("%[.-%]", styled, 1)

  local package_info = string.format("(%s)", item.containerName or "")
  item.text = item.text .. M.utils.nbsp .. with_hl(package_info, "Title")

  local symbol = item.text
  item.text = nil

  local line = M.make_entry.lcol(item, {})
  if line then
    return symbol .. M.utils.nbsp .. line
  end
end

---@param package_item PackageItem
---@return string
local function to_package_line(package_item)
  local icon = with_hl("󰏗 ", "Comment")
  local source_kind = with_hl("[" .. package_item.source_kind .. "]", "Title")
  return string.format(
    "%s%s%s%s%s",
    icon,
    package_item.package_name,
    M.utils.nbsp,
    source_kind,
    M.utils.nbsp .. package_item.import_path
  )
end

---@param interface_item InterfaceItem
---@return string
local function to_package_interface_line(interface_item)
  local icon = with_hl("󰰄 ", "Comment")
  local interface_name = (interface_item.name or "") .. format_type_parameters(interface_item.generic_parameters)
  local import_path = with_hl("(" .. (interface_item.import_path or interface_item.package_name or "") .. ")", "Title")
  local location = string.format("%s:%d:%d:", interface_item.path, interface_item.line, interface_item.col)
  return string.format("%s%s%s%s%s%s", icon, interface_name, M.utils.nbsp, import_path, M.utils.nbsp, location)
end

local WorkspacePreviewer = nil

-- Custom previewer for the mixed workspace/catalog picker
---@return table
local function workspace_previewer()
  if WorkspacePreviewer then
    return WorkspacePreviewer
  end

  WorkspacePreviewer = M.previewer_builtin.buffer_or_file:extend()

  function WorkspacePreviewer:new(o, opts, fzf_win)
    self.super.new(self, o, opts, fzf_win)
    setmetatable(self, WorkspacePreviewer)
    return self
  end

  function WorkspacePreviewer:populate_preview_buf(entry_str)
    local entry = self.opts._goimpl_resolve_entry and self.opts._goimpl_resolve_entry(entry_str) or nil
    if entry and entry.kind == "fallback" then
      -- The fallback row is not a file-backed item. Rendering a tiny synthetic
      -- preview avoids the default file previewer trying to stat that label.
      local buf = self:get_tmp_buffer()
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        "Press <CR> to search packages and dependencies.",
        "",
        string.format("Current query: %s", entry.query or ""),
      })
      self:set_preview_buf(buf)
      self.win:update_preview_title("goimpl fallback")
      return
    end

    return M.previewer_builtin.buffer_or_file.populate_preview_buf(self, entry_str)
  end

  return WorkspacePreviewer
end

-- Query splitting helpers used by fallback mode
---@param query string
---@return string?, string?
local function split_raw_query(query)
  query = vim.trim(query or "")
  if query == "" then
    return nil, nil
  end

  local split_at = query:match("^.*()%.")
  if split_at and split_at > 1 and split_at < #query then
    local package_name = query:sub(1, split_at - 1)
    local interface_name = query:sub(split_at + 1)
    if package_name ~= "" and interface_name ~= "" then
      return package_name, interface_name:gsub("%b[]", "")
    end
  end

  return nil, nil
end

---@param query string
---@return string
local function package_query_for_fallback(query)
  local package_name = split_raw_query(query)
  if package_name then
    return package_name
  end
  return query or ""
end

---@param query string
---@return string
local function interface_query_for_picker(query)
  local _, interface_name = split_raw_query(query)
  if interface_name then
    return interface_name
  end
  return query or ""
end

---@param interfaces InterfaceItem[]
---@param query string
---@return boolean
local function interfaces_have_query_match(interfaces, query)
  query = vim.trim(query or ""):lower()
  if query == "" then
    return true
  end

  for _, interface_item in ipairs(interfaces) do
    local name = (interface_item.name or ""):lower()
    if name:find(query, 1, true) then
      return true
    end
  end

  return false
end

-- Entry bookkeeping and selection recovery
---@param current_entries table<string, InterfaceItem>
---@param interface_item InterfaceItem
---@param formatter fun(item: InterfaceItem): string
---@param fzf_cb fun(line?: string, cb?: fun())
---@return boolean
local function emit_interface_entry(current_entries, interface_item, formatter, fzf_cb)
  local line = formatter(interface_item)
  if current_entries[line] then
    return false
  end

  current_entries[line] = interface_item
  local stripped_line = M.utils.strip_ansi_coloring(line)
  if stripped_line ~= line and not current_entries[stripped_line] then
    current_entries[stripped_line] = interface_item
  end
  fzf_cb(line)
  return true
end

---@param line string?
---@return string?, integer?, integer?
local function parse_entry_location(line)
  if not line or line == "" then
    return nil, nil, nil
  end

  local stripped = M.utils.strip_ansi_coloring(line)
  local path, row, col = stripped:match("(%S+):(%d+):(%d+):?$")
  if not path or not row or not col then
    return nil, nil, nil
  end

  return path, tonumber(row), tonumber(col)
end

---@param entry_map table<string, any>
---@param line string?
---@param entries any[]?
---@return any?
local function resolve_selected_entry(entry_map, line, entries)
  if not line then
    return nil
  end

  -- fzf selections may come back with ANSI styling or with only the file
  -- location suffix preserved, so resolution needs a few fallback strategies.
  if entry_map[line] then
    return entry_map[line]
  end

  local stripped = M.utils.strip_ansi_coloring(line)
  if entry_map[stripped] then
    return entry_map[stripped]
  end

  local path, row, col = parse_entry_location(line)
  if not path or not entries then
    return nil
  end

  for _, item in ipairs(entries) do
    if item.path == path and item.line == row and item.col == col then
      return item
    end
  end

  return nil
end

-- Live workspace picker settings
---@param bufnr integer current buffer number
---@param gopls vim.lsp.Client gopls (go language server)
---@param enable_fallback boolean
---@return { contents: fun(query: table): function, resolve: fun(line: string?): InterfaceItem? }
local function workspace_settings(bufnr, gopls, enable_fallback)
  local hl_query = "Title"
  if not M.utils.ansi_codes[hl_query] then
    local _, escseq = M.utils.ansi_from_hl(hl_query)
    M.utils.cache_ansi_escseq(hl_query, escseq)
  end

  ---@type integer?
  local running_request_id = -1
  local current_entries = {}

  local contents = function(query)
    return function(fzf_cb)
      if gopls and running_request_id ~= -1 then
        gopls:cancel_request(running_request_id)
      end

      if type(query) == "table" then
        query = query[1]
      end
      query = query or ""
      current_entries = {}
      local visible_count = 0

      if enable_fallback and query ~= "" and catalog.should_inline_search(query) then
        -- Merge catalog hits directly into the first picker so names like
        -- `Reader` can surface stdlib/dependency interfaces without forcing the
        -- user through a second package-selection step every time.
        local external_matches = catalog.search_interfaces(bufnr, gopls, query)
        if type(external_matches) == "table" then
          for _, interface_item in ipairs(external_matches) do
            if emit_interface_entry(current_entries, interface_item, to_package_interface_line, fzf_cb) then
              visible_count = visible_count + 1
            end
          end
        end
      end

      if not gopls then
        if enable_fallback and query ~= "" and visible_count == 0 then
          local fallback_line = format_fallback_line(query)
          current_entries[fallback_line] = {
            kind = "fallback",
            query = query,
          }
          fzf_cb(fallback_line)
        end
        return fzf_cb()
      end

      coroutine.wrap(function()
        local co = coroutine.running()
        -- Keep asking gopls for workspace symbols while the user types, but
        -- cancel any stale in-flight request to avoid old results flashing in.
        local request_success, request_id = gopls:request("workspace/symbol", {
          query = query,
        }, function(err, result)
          running_request_id = -1
          if err or not result or type(result) ~= "table" then
            return coroutine.resume(co, {})
          end

          local interface_symbols = vim
            .iter(result)
            :filter(function(symbol)
              return vim.lsp.protocol.SymbolKind[symbol.kind] == "Interface"
            end)
            :totable()

          local offset_encoding = gopls.offset_encoding or "utf-16"
          local items = vim.lsp.util.symbols_to_items(interface_symbols, bufnr, offset_encoding)

          for i, item in ipairs(items) do
            item.containerName = interface_symbols[i].containerName
          end

          coroutine.resume(co, items)
        end, bufnr)

        if not request_success then
          return fzf_cb()
        end

        running_request_id = request_id

        for _, item in ipairs(coroutine.yield()) do
          local line = to_workspace_line(item, query)
          if line then
            local entry = {
              kind = "interface",
              container_name = item.containerName,
              import_path = item.containerName,
              package_name = item.containerName,
              path = item.filename,
              line = item.lnum,
              col = item.col,
            }
            if not current_entries[line] then
              current_entries[line] = entry
              local stripped_line = M.utils.strip_ansi_coloring(line)
              if stripped_line ~= line and not current_entries[stripped_line] then
                current_entries[stripped_line] = entry
              end
              visible_count = visible_count + 1
              fzf_cb(line)
            end
          end
        end

        if enable_fallback and query ~= "" and visible_count == 0 then
          local fallback_line = format_fallback_line(query)
          current_entries[fallback_line] = {
            kind = "fallback",
            query = query,
          }
          fzf_cb(fallback_line)
        end

        fzf_cb()
      end)()
    end
  end

  return {
    contents = contents,
    resolve = function(line)
      return resolve_selected_entry(current_entries, line)
    end,
  }
end

-- User-facing picker entrypoints
---@param co thread
---@param bufnr integer current buffer number
---@param gopls vim.lsp.Client? gopls (go language server)
---@param enable_fallback boolean
---@return InterfaceItem?
function M.pick_workspace_interface(co, bufnr, gopls, enable_fallback)
  local settings = workspace_settings(bufnr, gopls, enable_fallback)

  M.core.fzf_live(settings.contents, {
    prompt = " 󰰄  > ",
    func_async_callback = false,
    previewer = function()
      return workspace_previewer()
    end,
    _goimpl_resolve_entry = settings.resolve,
    actions = {
      ["default"] = function(selected)
        local resolved = settings.resolve(selected and selected[1])
        if selected and selected[1] and not resolved then
          vim.notify("Failed to resolve the selected interface entry", vim.log.levels.WARN, { title = "fzf-goimpl" })
        end
        coroutine.resume(co, resolved)
      end,
    },
  })

  return coroutine.yield()
end

---@param co thread
---@param packages PackageItem[]
---@param initial_query string
---@return PackageItem?
function M.pick_package(co, packages, initial_query)
  local entry_map = {}
  local entries = {}

  -- `fzf_exec` is enough here because the package list is already fully known.
  for _, package_item in ipairs(packages) do
    local line = to_package_line(package_item)
    entry_map[line] = package_item
    local stripped_line = M.utils.strip_ansi_coloring(line)
    if stripped_line ~= line and not entry_map[stripped_line] then
      entry_map[stripped_line] = package_item
    end
    entries[#entries + 1] = line
  end

  M.core.fzf_exec(entries, {
    prompt = " 󰏗  > ",
    query = initial_query,
    previewer = false,
    actions = {
      ["default"] = function(selected)
        local resolved = resolve_selected_entry(entry_map, selected and selected[1], packages)
        if selected and selected[1] and not resolved then
          vim.notify("Failed to resolve the selected package entry", vim.log.levels.WARN, { title = "fzf-goimpl" })
        end
        coroutine.resume(co, resolved)
      end,
    },
  })

  return coroutine.yield()
end

---@param co thread
---@param interfaces InterfaceItem[]
---@param initial_query string
---@return InterfaceItem?
function M.pick_package_interface(co, interfaces, initial_query)
  local entry_map = {}
  local entries = {}

  -- Package-local interface lists are static, so this second-stage picker is a
  -- simple filtered list over pre-rendered entries.
  for _, interface_item in ipairs(interfaces) do
    local line = to_package_interface_line(interface_item)
    entry_map[line] = interface_item
    local stripped_line = M.utils.strip_ansi_coloring(line)
    if stripped_line ~= line and not entry_map[stripped_line] then
      entry_map[stripped_line] = interface_item
    end
    entries[#entries + 1] = line
  end

  M.core.fzf_exec(entries, {
    prompt = " 󰰄  > ",
    query = initial_query,
    previewer = M.defaults._default_previewer_fn,
    actions = {
      ["default"] = function(selected)
        local resolved = resolve_selected_entry(entry_map, selected and selected[1], interfaces)
        if selected and selected[1] and not resolved then
          vim.notify("Failed to resolve the selected interface entry", vim.log.levels.WARN, { title = "fzf-goimpl" })
        end
        coroutine.resume(co, resolved)
      end,
    },
  })

  return coroutine.yield()
end

---@param co thread
---@param bufnr integer
---@param gopls vim.lsp.Client?
---@param initial_query string
---@return InterfaceItem?
function M.pick_catalog_interface(co, bufnr, gopls, initial_query)
  local package_query = package_query_for_fallback(initial_query)
  local interface_query = interface_query_for_picker(initial_query)

  if initial_query and initial_query ~= "" then
    -- If the initial query already narrows down to interfaces, skip the extra
    -- package picker and let the user choose the final symbol immediately.
    local matched_interfaces, search_err = catalog.search_interfaces(bufnr, gopls, initial_query)
    if search_err then
      vim.notify(search_err, vim.log.levels.WARN, { title = "fzf-goimpl" })
      return nil
    end

    if matched_interfaces and #matched_interfaces > 0 then
      return M.pick_package_interface(co, matched_interfaces, interface_query)
    end
  end

  local packages, err = catalog.get_packages(bufnr, gopls)
  if err then
    vim.notify(err, vim.log.levels.WARN, { title = "fzf-goimpl" })
    return nil
  end

  if not packages or #packages == 0 then
    vim.notify("No Go packages found for package fallback", vim.log.levels.WARN, { title = "fzf-goimpl" })
    return nil
  end

  if initial_query and initial_query ~= "" then
    vim.notify("No interface matches found, switching to package picker", vim.log.levels.INFO, { title = "fzf-goimpl" })
  end

  local package_item = M.pick_package(co, packages, package_query)
  while package_item do
    -- The fallback flow is package -> interfaces inside that package. Keeping
    -- this as a loop lets the user backtrack and pick a different package.
    local interfaces, interface_err = catalog.get_package_interfaces(package_item)
    if interface_err then
      vim.notify(interface_err, vim.log.levels.WARN, { title = "fzf-goimpl" })
    elseif interfaces and #interfaces > 0 then
      -- When the original query was misspelled (`io.Writter`), do not keep the
      -- interface picker empty forever. Fall back to the package's full list.
      local picker_query = interface_query
      if picker_query ~= "" and not interfaces_have_query_match(interfaces, picker_query) then
        picker_query = ""
      end
      return M.pick_package_interface(co, interfaces, picker_query)
    else
      vim.notify("No interfaces found in " .. package_item.import_path, vim.log.levels.INFO, { title = "fzf-goimpl" })
    end

    package_item = M.pick_package(co, packages, package_item.import_path)
  end

  return nil
end

return M
