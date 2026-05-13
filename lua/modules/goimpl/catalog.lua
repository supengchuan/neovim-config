local Job = require("plenary.job")

local helper = require("modules.goimpl.helper")

local M = {}

local uv = vim.uv or vim.loop

-- In-memory caches
---@type table<string, { signature: string, packages: PackageItem[] }>
local package_cache = {}

---@type table<string, { signature: string, interfaces: InterfaceItem[] }>
local interface_cache = {}

---@type table<string, { signature: string, interfaces: InterfaceItem[] }>
local interface_symbol_cache = {}

local root_markers = {
  "go.work",
  "go.mod",
}

local metadata_files = {
  "go.mod",
  "go.sum",
  "go.work",
  "go.work.sum",
}

local source_kind_order = {
  workspace = 1,
  dependency = 2,
  stdlib = 3,
}

local goroot_cache = nil
local go_cache_dir = (vim.env.TMPDIR or "/tmp") .. "/fzf-goimpl-go-build"

-- Query parsing and search heuristics
-- Search input is normalized once so the matching rules can compare
-- `Reader`, `io.Reader`, and generic forms like `Reader[T]` consistently.
---@param value string?
---@return string
local function normalize_query(value)
  value = value or ""
  value = vim.trim(value)
  value = value:gsub("%s+", "")
  value = value:gsub("%b[]", "")
  return value:lower()
end

---@param query string?
---@return QueryParts
function M.parse_query_parts(query)
  local normalized = normalize_query(query)
  local parts = {
    raw = query or "",
    normalized = normalized,
    package_name = nil,
    interface_name = nil,
    qualified = false,
  }

  local split_at = normalized:match("^.*()%.")
  if split_at and split_at > 1 and split_at < #normalized then
    parts.package_name = normalized:sub(1, split_at - 1)
    parts.interface_name = normalized:sub(split_at + 1)
    parts.qualified = parts.package_name ~= "" and parts.interface_name ~= ""
  end

  return parts
end

---@param query string?
---@return boolean
function M.should_inline_search(query)
  local parts = M.parse_query_parts(query)
  if parts.qualified then
    return true
  end

  return #parts.normalized >= 2
end

-- Root discovery and cache invalidation
---@param path string
---@return string?
local function find_upwards(path)
  for _, marker in ipairs(root_markers) do
    local found = vim.fs.find(marker, {
      path = path,
      upward = true,
      type = "file",
    })[1]
    if found then
      return vim.fs.dirname(found)
    end
  end
end

---@param bufnr integer
---@return string?
function M.get_root(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return find_upwards(uv.cwd())
  end

  return find_upwards(vim.fs.dirname(name))
end

---@param root string
---@return string
local function metadata_signature(root)
  local parts = {}

  for _, file in ipairs(metadata_files) do
    local path = root .. "/" .. file
    local stat = uv.fs_stat(path)
    if stat and stat.mtime then
      parts[#parts + 1] = string.format("%s:%s:%s:%s", file, stat.mtime.sec or 0, stat.mtime.nsec or 0, stat.size or 0)
    end
  end

  return table.concat(parts, "|")
end

-- Build flags and package classification
---@param gopls vim.lsp.Client?
---@return string[]
local function get_build_flags(gopls)
  if not gopls or not gopls.config then
    return {}
  end

  local settings = gopls.config.settings or {}
  local gopls_settings = settings.gopls or {}
  if type(gopls_settings.buildFlags) ~= "table" then
    return {}
  end

  return vim.deepcopy(gopls_settings.buildFlags)
end

---@param root string
---@param build_flags string[]
---@return string
local function package_cache_key(root, build_flags)
  return root .. "::" .. table.concat(build_flags, "\0")
end

---@param pkg table
---@param root string
---@return string
local function classify_source_kind(pkg, root)
  if pkg.Standard then
    return "stdlib"
  end

  if pkg.Dir and vim.startswith(pkg.Dir, root) then
    return "workspace"
  end

  return "dependency"
end

---@param pkg table
---@return boolean
local function should_include_package(pkg)
  if not pkg or type(pkg) ~= "table" then
    return false
  end

  if not pkg.Dir or pkg.Dir == "" then
    return false
  end

  if pkg.ForTest and pkg.ForTest ~= "" then
    return false
  end

  if type(pkg.ImportPath) == "string" and pkg.ImportPath:find("%[") then
    return false
  end

  return true
end

-- External command runners
---@param cwd string?
---@param args string[]
---@return string[]?, string?
local function run_go_command(cwd, args)
  local stderr = {}
  -- Give `go list` a writable cache even when Neovim is launched from a
  -- restricted environment; otherwise catalog building can fail unexpectedly.
  vim.fn.mkdir(go_cache_dir, "p")
  local env = vim.fn.environ()
  env.GOCACHE = go_cache_dir
  local job = Job:new({
    command = "go",
    args = args,
    cwd = cwd,
    env = env,
    on_stderr = function(_, data)
      if data and data ~= "" then
        stderr[#stderr + 1] = data
      end
    end,
  })
  local ok, lines = pcall(function()
    return job:sync()
  end)

  if not ok then
    return nil, #stderr > 0 and table.concat(stderr, "\n") or "go command failed while building package catalog"
  end

  return lines or {}, nil
end

---@param command string
---@param cwd string?
---@param args string[]
---@return string[]?, string?
local function run_command(command, cwd, args)
  local stderr = {}
  local job = Job:new({
    command = command,
    args = args,
    cwd = cwd,
    on_stderr = function(_, data)
      if data and data ~= "" then
        stderr[#stderr + 1] = data
      end
    end,
  })
  local ok, lines = pcall(function()
    return job:sync()
  end)

  if not ok then
    return nil, #stderr > 0 and table.concat(stderr, "\n") or (command .. " command failed")
  end

  return lines or {}, nil
end

---@param text string
---@return table[]
local function decode_json_stream(text)
  local objects = {}
  local start_idx = nil
  local depth = 0
  local in_string = false
  local escaping = false

  for i = 1, #text do
    local char = text:sub(i, i)
    if escaping then
      escaping = false
    elseif char == "\\" and in_string then
      escaping = true
    elseif char == '"' then
      in_string = not in_string
    elseif not in_string then
      if char == "{" then
        if depth == 0 then
          start_idx = i
        end
        depth = depth + 1
      elseif char == "}" then
        depth = depth - 1
        if depth == 0 and start_idx then
          local ok, decoded = pcall(vim.json.decode, text:sub(start_idx, i))
          if ok and decoded then
            objects[#objects + 1] = decoded
          end
          start_idx = nil
        end
      end
    end
  end

  return objects
end

-- Package collection
---@param root string
---@param build_flags string[]
---@param patterns string[]
---@return table<string, PackageItem>, string?
local function collect_packages(root, build_flags, patterns)
  -- `go list -json` is the authoritative source for package metadata. We use it
  -- for both the workspace and dependency graph, then add stdlib separately.
  local args = { "list", "-json" }
  vim.list_extend(args, build_flags)
  vim.list_extend(args, patterns)

  local lines, err = run_go_command(root, args)
  if err then
    return {}, err
  end

  local result = {}
  for _, pkg in ipairs(decode_json_stream(table.concat(lines or {}, "\n"))) do
    if should_include_package(pkg) then
      local import_path = pkg.ImportPath
      result[import_path] = {
        import_path = import_path,
        package_name = pkg.Name,
        dir = pkg.Dir,
        source_kind = classify_source_kind(pkg, root),
      }
    end
  end

  return result, nil
end

---@return string?, string?
local function get_goroot()
  if goroot_cache then
    return goroot_cache, nil
  end

  local lines, err = run_go_command(nil, { "env", "GOROOT" })
  if err then
    return nil, err
  end

  local goroot = lines and lines[1] or nil
  if not goroot or goroot == "" then
    return nil, "cannot determine GOROOT"
  end

  goroot_cache = goroot
  return goroot, nil
end

---@param dir string
---@param callback fun(path: string)
local function walk_dirs(dir, callback)
  callback(dir)

  for name, file_type in vim.fs.dir(dir) do
    if file_type == "directory" and name ~= "testdata" and not vim.startswith(name, ".") and name ~= "cmd" then
      walk_dirs(dir .. "/" .. name, callback)
    end
  end
end

---@return table<string, PackageItem>, string?
local function collect_stdlib_packages()
  local goroot, err = get_goroot()
  if err then
    return {}, err
  end

  local result = {}
  local lines, list_err = run_go_command(nil, { "list", "-f", "{{.ImportPath}}\t{{.Name}}\t{{.Dir}}", "std" })
  if list_err then
    return {}, list_err
  end

  for _, line in ipairs(lines or {}) do
    local import_path, package_name, dir = line:match("^([^\t]+)\t([^\t]+)\t(.+)$")
    if import_path and package_name and dir and vim.startswith(dir, goroot) then
      result[import_path] = {
        import_path = import_path,
        package_name = package_name,
        dir = dir,
        source_kind = "stdlib",
      }
    end
  end

  return result, nil
end

-- Package sorting and package-cache entrypoint
---@param packages PackageItem[]
local function sort_packages(packages)
  table.sort(packages, function(a, b)
    local left = source_kind_order[a.source_kind] or math.huge
    local right = source_kind_order[b.source_kind] or math.huge
    if left ~= right then
      return left < right
    end

    if a.package_name ~= b.package_name then
      return a.package_name < b.package_name
    end

    return a.import_path < b.import_path
  end)
end

---@param bufnr integer
---@param gopls vim.lsp.Client?
---@return PackageItem[]?, string?
function M.get_packages(bufnr, gopls)
  local root = M.get_root(bufnr)
  if not root then
    return nil, "cannot find go.work or go.mod for the current buffer"
  end

  local build_flags = get_build_flags(gopls)
  local cache_key = package_cache_key(root, build_flags)
  local signature = metadata_signature(root)
  local cached = package_cache[cache_key]
  if cached and cached.signature == signature then
    return vim.deepcopy(cached.packages), nil
  end

  local package_map = {}
  local patterns_list = {
    { "./..." },
    { "-deps", "./..." },
  }

  -- The first pass collects local packages; the second pass pulls in resolved
  -- dependencies reachable from the current module/workspace.
  for _, patterns in ipairs(patterns_list) do
    local partial, err = collect_packages(root, build_flags, patterns)
    if err and vim.tbl_isempty(partial) then
      return nil, err
    end
    for import_path, package_item in pairs(partial) do
      package_map[import_path] = package_item
    end
  end

  local stdlib_packages, stdlib_err = collect_stdlib_packages()
  if stdlib_err and vim.tbl_isempty(stdlib_packages) then
    return nil, stdlib_err
  end
  for import_path, package_item in pairs(stdlib_packages) do
    package_map[import_path] = package_item
  end

  local packages = vim.tbl_values(package_map)
  sort_packages(packages)

  package_cache[cache_key] = {
    signature = signature,
    packages = vim.deepcopy(packages),
  }

  return packages, nil
end

-- Per-package interface enumeration
---@param dir string
---@return string[], string
local function collect_go_files(dir)
  local files = {}

  for name, file_type in vim.fs.dir(dir) do
    if file_type == "file" and vim.endswith(name, ".go") and not vim.endswith(name, "_test.go") then
      files[#files + 1] = dir .. "/" .. name
    end
  end

  table.sort(files)

  local signature_parts = {}
  for _, path in ipairs(files) do
    local stat = uv.fs_stat(path)
    if stat and stat.mtime then
      signature_parts[#signature_parts + 1] =
        string.format("%s:%s:%s:%s", path, stat.mtime.sec or 0, stat.mtime.nsec or 0, stat.size or 0)
    end
  end

  return files, table.concat(signature_parts, "|")
end

---@param package_item PackageItem
---@return InterfaceItem[]?, string?
function M.get_package_interfaces(package_item)
  if not package_item or not package_item.dir then
    return nil, "invalid package item"
  end

  local files, signature = collect_go_files(package_item.dir)
  local cache_key = package_item.dir
  local cached = interface_cache[cache_key]
  if cached and cached.signature == signature then
    return vim.deepcopy(cached.interfaces), nil
  end

  local interfaces = {}
  for _, path in ipairs(files) do
    local items = helper.list_interfaces_in_file(path, package_item)
    if items then
      vim.list_extend(interfaces, items)
    end
  end

  table.sort(interfaces, function(a, b)
    local left_name = a.name or ""
    local right_name = b.name or ""
    if left_name ~= right_name then
      return left_name < right_name
    end

    if a.path ~= b.path then
      return a.path < b.path
    end

    return a.line < b.line
  end)

  interface_cache[cache_key] = {
    signature = signature,
    interfaces = vim.deepcopy(interfaces),
  }

  return interfaces, nil
end

-- Search scoring helpers
---@param haystack string?
---@param needle string
---@return boolean
local function contains_case_insensitive(haystack, needle)
  if not haystack or haystack == "" then
    return false
  end

  return haystack:lower():find(needle:lower(), 1, true) ~= nil
end

---@param interface_item InterfaceItem
---@return string, string, string, string, string
local function interface_match_keys(interface_item)
  local name = normalize_query(interface_item.name)
  local package_name = normalize_query(interface_item.package_name)
  local import_path = normalize_query(interface_item.import_path)
  local package_interface = package_name ~= "" and package_name .. "." .. name or name
  local import_interface = import_path ~= "" and import_path .. "." .. name or name
  return name, package_name, import_path, package_interface, import_interface
end

---@param interface_item InterfaceItem
---@param query_parts QueryParts
---@return integer?
local function interface_match_score(interface_item, query_parts)
  if not query_parts.normalized or query_parts.normalized == "" then
    return nil
  end

  -- Higher scores mean "closer to what the user probably meant". Exact
  -- qualified matches should beat plain name matches, but fuzzy package/name
  -- combinations still remain searchable.
  local name, package_name, import_path, package_interface, import_interface = interface_match_keys(interface_item)
  local query = query_parts.normalized

  if query_parts.qualified then
    local query_package = query_parts.package_name or ""
    local query_interface = query_parts.interface_name or ""
    local exact_name = name == query_interface
    local contains_name = contains_case_insensitive(name, query_interface)
    local exact_import = import_path == query_package
    local exact_package = package_name == query_package
    local contains_import = contains_case_insensitive(import_path, query_package)
    local contains_package = contains_case_insensitive(package_name, query_package)

    if import_interface == query then
      return 1000
    end
    if package_interface == query then
      return 950
    end
    if exact_import and exact_name then
      return 900
    end
    if exact_package and exact_name then
      return 850
    end
    if exact_import and contains_name then
      return 800
    end
    if exact_package and contains_name then
      return 750
    end
    if contains_case_insensitive(import_interface, query) then
      return 700
    end
    if contains_case_insensitive(package_interface, query) then
      return 650
    end
    if contains_import and exact_name then
      return 600
    end
    if contains_package and exact_name then
      return 550
    end
    if (contains_import or contains_package) and contains_name then
      return 500
    end
    return nil
  end

  if name == query then
    return 400
  end
  if package_interface == query then
    return 350
  end
  if import_interface == query then
    return 325
  end
  if contains_case_insensitive(name, query) then
    return 300
  end
  if contains_case_insensitive(package_interface, query) then
    return 250
  end
  if contains_case_insensitive(import_interface, query) then
    return 225
  end
  if contains_case_insensitive(import_path, query) then
    return 200
  end
  if contains_case_insensitive(package_name, query) then
    return 175
  end

  return nil
end

-- Qualified query prefiltering
---@param package_item PackageItem
---@param query_parts QueryParts
---@return boolean
local function package_matches_query(package_item, query_parts)
  if not query_parts.qualified then
    return true
  end

  local query_package = query_parts.package_name or ""
  if query_package == "" then
    return true
  end

  local import_path = normalize_query(package_item.import_path)
  local package_name = normalize_query(package_item.package_name)
  if import_path == query_package or package_name == query_package then
    return true
  end

  if vim.endswith(import_path, "/" .. query_package) then
    return true
  end

  if contains_case_insensitive(import_path, query_package) or contains_case_insensitive(package_name, query_package) then
    return true
  end

  return false
end

---@param root string
---@param build_flags string[]
---@return string
local function interface_symbol_cache_key(root, build_flags)
  return package_cache_key(root, build_flags)
end

local interface_decl_pattern = "^\\s*type\\s+([A-Za-z_][A-Za-z0-9_]*)(\\[[^\\]]+\\])?\\s+interface\\s*\\{"

---@param root string
---@param packages PackageItem[]
---@return string[], table<string, PackageItem>
local function build_search_roots(root, packages)
  local roots_map = {}
  local dir_lookup = {}
  local goroot, _ = get_goroot()
  local goroot_src = goroot and (goroot .. "/src") or nil

  for _, package_item in ipairs(packages) do
    dir_lookup[package_item.dir] = package_item

    local search_root = package_item.dir
    if package_item.source_kind == "workspace" then
      search_root = root
    elseif package_item.source_kind == "stdlib" and goroot_src then
      search_root = goroot_src
    else
      -- Dependency packages often live deep under module caches. Collapsing to
      -- their shared parent keeps the ripgrep invocation from exploding into
      -- thousands of near-duplicate root arguments.
      local pkg_mod_root = package_item.dir:match("^(.-/pkg/mod/)")
      local vendor_root = package_item.dir:match("^(.-/vendor/)")
      if pkg_mod_root then
        search_root = pkg_mod_root
      elseif vendor_root then
        search_root = vendor_root
      end
    end

    roots_map[search_root] = true
  end

  local roots = vim.tbl_keys(roots_map)
  table.sort(roots)
  return roots, dir_lookup
end

---@param path string
---@param dir_lookup table<string, PackageItem>
---@return PackageItem?
local function resolve_package_for_file(path, dir_lookup)
  return dir_lookup[vim.fs.dirname(path)]
end

---@param bufnr integer
---@param gopls vim.lsp.Client?
---@return InterfaceItem[]?, string?
function M.get_interface_symbol_index(bufnr, gopls)
  local root = M.get_root(bufnr)
  if not root then
    return nil, "cannot find go.work or go.mod for the current buffer"
  end

  local build_flags = get_build_flags(gopls)
  local cache_key = interface_symbol_cache_key(root, build_flags)
  local signature = metadata_signature(root)
  local cached = interface_symbol_cache[cache_key]
  if cached and cached.signature == signature then
    return vim.deepcopy(cached.interfaces), nil
  end

  local packages, err = M.get_packages(bufnr, gopls)
  if err then
    return nil, err
  end

  if not packages or #packages == 0 then
    return {}, nil
  end

  local search_roots, dir_lookup = build_search_roots(root, packages)
  -- The external symbol index is intentionally cheap: ripgrep finds candidate
  -- `type X interface {` declarations, and Treesitter only does the expensive
  -- parse later for the single interface the user actually picks.
  local args = {
    "--no-heading",
    "--color=never",
    "--with-filename",
    "--line-number",
    "--column",
    "--glob",
    "*.go",
    "--glob",
    "!*_test.go",
    "-P",
    "-e",
    interface_decl_pattern,
  }
  vim.list_extend(args, search_roots)

  local lines, rg_err = run_command("rg", root, args)
  if rg_err then
    return nil, rg_err
  end

  local interfaces = {}
  local seen = {}
  for _, line in ipairs(lines or {}) do
    local path, row, col, text = line:match("^(.-):(%d+):(%d+):(.*)$")
    local package_item = path and resolve_package_for_file(path, dir_lookup) or nil
    local interface_name = text and text:match("^%s*type%s+([%w_]+)") or nil
    local key = path and row and col and (path .. ":" .. row .. ":" .. col) or nil

    if package_item and interface_name and key and not seen[key] then
      seen[key] = true
      interfaces[#interfaces + 1] = {
        name = interface_name,
        import_path = package_item.import_path,
        package_name = package_item.package_name,
        source_kind = package_item.source_kind,
        path = path,
        line = tonumber(row),
        col = tonumber(col),
        container_name = package_item.import_path,
      }
    end
  end

  table.sort(interfaces, function(a, b)
    local left_name = a.name or ""
    local right_name = b.name or ""
    if left_name ~= right_name then
      return left_name < right_name
    end

    local left_kind = source_kind_order[a.source_kind] or math.huge
    local right_kind = source_kind_order[b.source_kind] or math.huge
    if left_kind ~= right_kind then
      return left_kind < right_kind
    end

    local left_import = a.import_path or ""
    local right_import = b.import_path or ""
    if left_import ~= right_import then
      return left_import < right_import
    end

    if a.path ~= b.path then
      return a.path < b.path
    end

    return a.line < b.line
  end)

  interface_symbol_cache[cache_key] = {
    signature = signature,
    interfaces = vim.deepcopy(interfaces),
  }

  return interfaces, nil
end

-- In-memory interface search over the prebuilt symbol index
---@param bufnr integer
---@param gopls vim.lsp.Client?
---@param query string
---@return InterfaceItem[]?, string?
function M.search_interfaces(bufnr, gopls, query)
  local interfaces, err = M.get_interface_symbol_index(bufnr, gopls)
  if err then
    return nil, err
  end

  if not interfaces or #interfaces == 0 then
    return {}, nil
  end

  local query_parts = M.parse_query_parts(query)
  if query_parts.normalized == "" then
    return {}, nil
  end

  -- Search is purely in-memory once the index exists, which keeps repeated
  -- picker updates responsive even when the package universe is large.
  local matches = {}
  for _, interface_item in ipairs(interfaces) do
    if not query_parts.qualified or package_matches_query({
      import_path = interface_item.import_path,
      package_name = interface_item.package_name,
    }, query_parts) then
      local match_score = interface_match_score(interface_item, query_parts)
      if match_score then
        local entry = vim.deepcopy(interface_item)
        entry.match_score = match_score
        matches[#matches + 1] = entry
      end
    end
  end

  table.sort(matches, function(a, b)
    local left_score = a.match_score or -1
    local right_score = b.match_score or -1
    if left_score ~= right_score then
      return left_score > right_score
    end

    local left_name = a.name or ""
    local right_name = b.name or ""
    if left_name ~= right_name then
      return left_name < right_name
    end

    local left_kind = source_kind_order[a.source_kind] or math.huge
    local right_kind = source_kind_order[b.source_kind] or math.huge
    if left_kind ~= right_kind then
      return left_kind < right_kind
    end

    local left_import = a.import_path or ""
    local right_import = b.import_path or ""
    if left_import ~= right_import then
      return left_import < right_import
    end

    if a.path ~= b.path then
      return a.path < b.path
    end

    return a.line < b.line
  end)

  return matches, nil
end

return M
