local M = {}

local module_cache = {}

local function sorted_cache_keys()
  local keys = vim.tbl_keys(module_cache)
  table.sort(keys)
  return keys
end

function M.get_module(start_dir)
  local gomod = vim.fs.find("go.mod", {
    upward = true,
    path = start_dir,
  })[1]

  if not gomod then
    return nil
  end

  local stat = vim.uv.fs_stat(gomod)
  if not stat then
    module_cache[gomod] = nil
    return nil
  end

  local cache_key = string.format("%s:%s:%s", stat.mtime.sec, stat.mtime.nsec, stat.size)
  local cached = module_cache[gomod]
  if cached and cached.key == cache_key then
    return cached.module
  end

  local file = io.open(gomod, "r")
  if not file then
    module_cache[gomod] = { key = cache_key, module = nil }
    return nil
  end

  local module_name = nil
  for line in file:lines() do
    module_name = line:match("^module%s+(.+)$")
    if module_name then
      break
    end
  end

  file:close()
  module_cache[gomod] = { key = cache_key, module = module_name }
  return module_name
end

function M.goimports_args(ctx)
  local args = { "-srcdir", ctx.dirname }
  local module_name = M.get_module(ctx.dirname)
  if module_name then
    vim.list_extend(args, { "-local", module_name })
  end
  return args
end

function M.get_module_cache()
  local cache = {}
  for _, gomod in ipairs(sorted_cache_keys()) do
    local entry = module_cache[gomod]
    cache[gomod] = {
      key = entry.key,
      module = entry.module,
    }
  end
  return cache
end

function M.print_module_cache()
  local cache = M.get_module_cache()
  if vim.tbl_isempty(cache) then
    vim.notify("Go module cache is empty", vim.log.levels.INFO)
    return
  end

  vim.print(cache)
end

return M
