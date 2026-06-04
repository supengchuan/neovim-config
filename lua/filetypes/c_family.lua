local M = {}

local c_standard_headers = {
  ["ctype.h"] = {
    "isalnum",
    "isalpha",
    "iscntrl",
    "isdigit",
    "isgraph",
    "islower",
    "isprint",
    "ispunct",
    "isspace",
    "isupper",
    "isxdigit",
    "tolower",
    "toupper",
  },
  ["math.h"] = {
    "acos",
    "asin",
    "atan",
    "atan2",
    "ceil",
    "cos",
    "exp",
    "fabs",
    "floor",
    "fmod",
    "log",
    "log10",
    "pow",
    "sin",
    "sqrt",
    "tan",
  },
  ["stddef.h"] = {
    "NULL",
    "offsetof",
    "ptrdiff_t",
    "size_t",
  },
  ["stdint.h"] = {
    "int8_t",
    "int16_t",
    "int32_t",
    "int64_t",
    "intptr_t",
    "uint8_t",
    "uint16_t",
    "uint32_t",
    "uint64_t",
    "uintptr_t",
  },
  ["stdio.h"] = {
    "fclose",
    "fflush",
    "fgetc",
    "fgets",
    "fopen",
    "fprintf",
    "fputc",
    "fputs",
    "fread",
    "fscanf",
    "fwrite",
    "getchar",
    "perror",
    "printf",
    "putchar",
    "puts",
    "scanf",
    "snprintf",
    "sprintf",
    "sscanf",
  },
  ["stdlib.h"] = {
    "abort",
    "abs",
    "atexit",
    "atof",
    "atoi",
    "atol",
    "bsearch",
    "calloc",
    "exit",
    "free",
    "getenv",
    "labs",
    "malloc",
    "qsort",
    "rand",
    "realloc",
    "srand",
    "strtod",
    "strtol",
    "strtoul",
  },
  ["string.h"] = {
    "memchr",
    "memcmp",
    "memcpy",
    "memmove",
    "memset",
    "strcat",
    "strchr",
    "strcmp",
    "strcpy",
    "strcspn",
    "strlen",
    "strncmp",
    "strncpy",
    "strrchr",
    "strspn",
    "strstr",
    "strtok",
  },
}

local function run_clangd_command(command, label)
  return function()
    local ok, err = pcall(vim.cmd, command)
    if ok then
      return
    end

    vim.notify(label .. " requires an attached clangd client: " .. tostring(err), vim.log.levels.WARN)
  end
end

local function strip_c_comments_and_strings(lines)
  local stripped = {}
  local in_block_comment = false

  for _, line in ipairs(lines) do
    local out = {}
    local i = 1

    while i <= #line do
      local char = line:sub(i, i)
      local pair = line:sub(i, i + 1)

      if in_block_comment then
        if pair == "*/" then
          in_block_comment = false
          i = i + 2
        else
          i = i + 1
        end
      elseif pair == "/*" then
        in_block_comment = true
        i = i + 2
      elseif pair == "//" then
        break
      elseif char == '"' or char == "'" then
        local quote = char
        table.insert(out, " ")
        i = i + 1
        while i <= #line do
          local current = line:sub(i, i)
          if current == "\\" then
            i = i + 2
          elseif current == quote then
            i = i + 1
            break
          else
            i = i + 1
          end
        end
      else
        table.insert(out, char)
        i = i + 1
      end
    end

    table.insert(stripped, table.concat(out))
  end

  return table.concat(stripped, "\n")
end

local function existing_headers(lines)
  local headers = {}

  for _, line in ipairs(lines) do
    local header = line:match('^%s*#%s*include%s*[<"]([^>"]+)[>"]')
    if header then
      headers[header] = true
    end
  end

  return headers
end

local function find_include_insert_index(lines)
  local last_include

  for index, line in ipairs(lines) do
    if line:match('^%s*#%s*include%s*[<"]') then
      last_include = index
    end
  end

  if last_include then
    return last_include
  end

  local index = 1
  while index <= #lines do
    local line = lines[index]

    if line:match("^%s*$") then
      index = index + 1
    elseif line:match("^%s*//") then
      repeat
        index = index + 1
      until index > #lines or not (lines[index] or ""):match("^%s*//")
    elseif line:match("^%s*/%*") then
      repeat
        index = index + 1
      until index > #lines or (lines[index - 1] or ""):find("*/", 1, true)
    else
      break
    end
  end

  return index - 1
end

local function missing_c_standard_headers(lines)
  local code = strip_c_comments_and_strings(lines)
  local included = existing_headers(lines)
  local missing = {}

  for header, symbols in pairs(c_standard_headers) do
    if not included[header] then
      for _, symbol in ipairs(symbols) do
        if code:find("%f[%w_]" .. symbol .. "%f[^%w_]") then
          table.insert(missing, header)
          break
        end
      end
    end
  end

  table.sort(missing)
  return missing
end

local function add_missing_c_standard_includes()
  if vim.bo.filetype ~= "c" or vim.bo.buftype ~= "" or vim.bo.readonly then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local missing = missing_c_standard_headers(lines)
  if #missing == 0 then
    return
  end

  local include_lines = vim.tbl_map(function(header)
    return "#include <" .. header .. ">"
  end, missing)

  local insert_index = find_include_insert_index(lines)
  local next_line = lines[insert_index + 1]
  if next_line and not next_line:match("^%s*$") then
    table.insert(include_lines, "")
  end

  vim.api.nvim_buf_set_lines(0, insert_index, insert_index, false, include_lines)
end

local function setup_c_standard_auto_includes()
  if vim.bo.filetype ~= "c" or vim.b.c_standard_auto_include_autocmd then
    return
  end

  vim.b.c_standard_auto_include_autocmd = true
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("NvimCStandardAutoIncludes", { clear = false }),
    buffer = 0,
    callback = add_missing_c_standard_includes,
  })
end

function M.setup()
  local common = require("filetypes.common")

  common.indent(4)
  common.text_width(120)
  setup_c_standard_auto_includes()

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
