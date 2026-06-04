local M = {}

local function is_empty_new_file(path)
  return path ~= ""
    and vim.bo.buftype == ""
    and vim.bo.modifiable
    and vim.fn.filereadable(path) == 0
    and vim.api.nvim_buf_line_count(0) == 1
    and vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == ""
end

local function include_guard(path)
  local name = vim.fn.fnamemodify(path, ":t")
  local guard = name:gsub("%W", "_"):upper()
  guard = guard:gsub("_+", "_"):gsub("^_", ""):gsub("_$", "")
  return guard ~= "" and guard or "HEADER_H"
end

local function file_header(path)
  return {
    "/*",
    " * File: " .. vim.fn.fnamemodify(path, ":t"),
    " * Created: " .. os.date("%Y-%m-%d %H:%M:%S"),
    " */",
  }
end

local function apply_new_file_template()
  local path = vim.api.nvim_buf_get_name(0)
  if not is_empty_new_file(path) then
    return
  end

  local ext = vim.fn.fnamemodify(path, ":e"):lower()
  local lines = file_header(path)

  if ext == "h" then
    local guard = include_guard(path)
    vim.list_extend(lines, {
      "",
      "#ifndef " .. guard,
      "#define " .. guard,
      "",
      "",
      "#endif /* " .. guard .. " */",
    })
  elseif ext ~= "c" then
    return
  else
    table.insert(lines, "")
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

  local cursor_line = ext == "h" and 8 or #lines
  vim.api.nvim_win_set_cursor(0, { cursor_line, 0 })
end

local function run_clangd_command(command, label)
  return function()
    local ok, err = pcall(vim.cmd, command)
    if ok then
      return
    end

    vim.notify(label .. " requires an attached clangd client: " .. tostring(err), vim.log.levels.WARN)
  end
end

function M.setup()
  local common = require("filetypes.common")

  common.indent(4)
  common.text_width(120)
  apply_new_file_template()

  vim.keymap.set(
    "n",
    "<leader>cH",
    run_clangd_command("LspClangdSwitchSourceHeader", "Switch source/header"),
    { buffer = true, desc = "switch source/header" }
  )

  vim.keymap.set(
    "n",
    "<leader>cS",
    run_clangd_command("LspClangdShowSymbolInfo", "Show clangd symbol info"),
    { buffer = true, desc = "show clangd symbol info" }
  )
end

return M
