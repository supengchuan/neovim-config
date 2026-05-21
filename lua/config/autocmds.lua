local myAutoGroup = vim.api.nvim_create_augroup("LocalGroup", {
  clear = true,
})

-- Clear the old Neo-tree scroll redraw hook when the config is sourced in a live session.
vim.api.nvim_create_augroup("LocalNeoTreeRedraw", {
  clear = true,
})

local auto_cmd = vim.api.nvim_create_autocmd
local prose_filetypes = {
  codecompanion = true,
  markdown = true,
  tex = true,
}

local function isolate_current_window()
  require("utils").IsolateWindow()
end

local function collect_python_import_positions(bufnr)
  local line_count = math.min(vim.api.nvim_buf_line_count(bufnr), 120)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, line_count, false)
  local positions = {}
  local in_from_import_block = false
  local skip_words = {
    ["as"] = true,
    ["from"] = true,
    ["import"] = true,
  }

  local function add_position(line_index, line, start_col, word)
    if skip_words[word] or #positions >= 24 then
      return
    end

    table.insert(positions, {
      line = line_index - 1,
      character = start_col - 1,
    })
  end

  for line_index, line in ipairs(lines) do
    local is_import_line = line:match("^%s*import%s+") or line:match("^%s*from%s+[%w_%.]+%s+import%s+")

    if is_import_line then
      for start_col, word in line:gmatch("()([%a_][%w_]*)") do
        add_position(line_index, line, start_col, word)
      end

      in_from_import_block = line:match("%(%s*$") ~= nil
    elseif in_from_import_block then
      if line:match("^%s*%)") then
        in_from_import_block = false
      else
        local start_col, word = line:find("([%a_][%w_]*)")
        if start_col and word then
          add_position(line_index, line, start_col, line:sub(start_col, word))
        end
      end
    end
  end

  return positions
end

local function warmup_pyright(client_id, bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local client = vim.lsp.get_client_by_id(client_id)
  if not client or client.name ~= "pyright" then
    return
  end

  local uri = vim.uri_from_bufnr(bufnr)

  if client:supports_method("textDocument/documentSymbol", bufnr) then
    client:request("textDocument/documentSymbol", {
      textDocument = { uri = uri },
    }, function() end, bufnr)
  end

  if not client:supports_method("textDocument/definition", bufnr) then
    return
  end

  for _, position in ipairs(collect_python_import_positions(bufnr)) do
    client:request("textDocument/definition", {
      textDocument = { uri = uri },
      position = position,
    }, function() end, bufnr)
  end
end

-- nvim-tree 自动关闭
--autocmd("BufEnter", {
--	nested = true,
--	group = myAutoGroup,
--	callback = function()
--		if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
--			vim.cmd("quit")
--		end
--	end,
--})

-- 进入Terminal 自动进入插入模式
auto_cmd("TermOpen", {
  group = myAutoGroup,
  command = "startinsert",
})

-- 自动保存
auto_cmd({ "InsertLeave", "TextChanged" }, {
  group = myAutoGroup,
  pattern = { "*" },
  command = "silent! wall",
})

-- 保存时自动格式化
auto_cmd("BufWritePre", {
  group = myAutoGroup,
  pattern = { "*.lua", "*.py", "*.go", "*.rs", "*.md" },
  --	callback = vim.lsp.buf.formatting_sync,
  command = "Format",
})

auto_cmd("BufWritePre", {
  group = myAutoGroup,
  pattern = { "*" },
  callback = function()
    local fn = vim.fn
    local dir = fn.expand("<afile>:p:h")

    -- This handles URLs using netrw. See ':help netrw-transparent' for details.
    if dir:find("%l+://") == 1 then
      return
    end

    if fn.isdirectory(dir) == 0 then
      fn.mkdir(dir, "p")
    end
  end,
})
-- Highlight on yank
--autocmd("TextYankPost", {
--	callback = function()
--		vim.highlight.on_yank()
--	end,
--	group = myAutoGroup,
--	pattern = "*",
--})

-- 用o换行不要延续注释
auto_cmd("BufEnter", {
  group = myAutoGroup,
  pattern = "*",
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions
      - "o" -- O and o, don't continue comments
      + "r" -- But do continue when pressing enter.
  end,
})

-- set rust file space chars
auto_cmd("BufEnter", {
  group = myAutoGroup,
  pattern = "*.rs",
  callback = function()
    -- only for current buffer
    vim.wo.listchars = "eol:\\u21b5,leadmultispace: ,space:.,tab:>-,trail:-"
  end,
})

-- reopen file in the same position
auto_cmd("BufReadPost", {
  callback = function()
    local row, col = unpack(vim.api.nvim_buf_get_mark(0, '"'))
    if { row, col } ~= { 0, 0 } then
      local max_rows = vim.api.nvim_buf_line_count(0)
      if max_rows < row then
        row = max_rows
      end
      vim.api.nvim_win_set_cursor(0, { row, 0 })
    end
  end,
  group = myAutoGroup,
})

-- wrap file according filetype
auto_cmd("FileType", {
  pattern = "*",
  group = myAutoGroup,
  callback = function(opts)
    isolate_current_window()

    if prose_filetypes[vim.bo[opts.buf].filetype] then
      vim.opt_local.colorcolumn = ""
      vim.opt_local.wrap = true
      require("utils").SetSoftWrapKeymaps(opts.buf)
    elseif vim.bo[opts.buf].buftype == "" then
      vim.opt_local.wrap = false
    end
  end,
})

auto_cmd("LspAttach", {
  group = myAutoGroup,
  callback = function(opts)
    local client = vim.lsp.get_client_by_id(opts.data.client_id)
    if not client or client.name ~= "pyright" or vim.bo[opts.buf].filetype ~= "python" then
      return
    end

    local warmup_key = "local_pyright_warmup_" .. client.id
    if vim.b[opts.buf][warmup_key] then
      return
    end
    vim.b[opts.buf][warmup_key] = true

    vim.defer_fn(function()
      warmup_pyright(client.id, opts.buf)
    end, 100)

    vim.defer_fn(function()
      warmup_pyright(client.id, opts.buf)
    end, 900)
  end,
})

auto_cmd({ "WinNew", "WinEnter", "BufWinEnter", "TabEnter" }, {
  group = myAutoGroup,
  callback = function()
    local utils = require("utils")
    utils.IsolateEditorWindows()
    utils.RememberAllWindowViews()
  end,
})

auto_cmd("WinScrolled", {
  group = myAutoGroup,
  callback = function()
    require("utils").RestoreNonCurrentWindowViews()
  end,
})

auto_cmd("OptionSet", {
  group = myAutoGroup,
  pattern = { "scrollbind", "cursorbind" },
  callback = function()
    require("utils").IsolateEditorWindows()
  end,
})

-- set tab as 4space for c or cpp
--autocmd("BufEnter", {
--	pattern = { "*.c", "*.cpp" },
--	group = myAutoGroup,
--	callback = function()
--		vim.o.expandtab = true
--	end,
--})

-- Turn off syntax highlighting for large files
auto_cmd("BufEnter", {
  group = myAutoGroup,
  pattern = "*",
  callback = function()
    if vim.api.nvim_buf_line_count(0) > 20000 then
      vim.cmd([[ syntax off ]])
    end
  end,
})

-- set <C-]> to jump to tag in nvim help document
-- because I mapped lsp_definition to <C-]>, it cannot jump to tag in nvim help documents
auto_cmd({ "FileType" }, {
  pattern = { "help" },
  callback = function(opts)
    vim.keymap.set("n", "<C-]>", "<C-]>", { silent = true, buffer = opts.buf })
  end,
})

-- add line number for telescope preview
auto_cmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function()
    vim.cmd([[setlocal number]])
  end,
})

-- cancel all list chars when start, so commnet codes blow
--autocmd({ "BufRead", "BufNewFile" }, {
--  callback = function()
--    vim.opt_local.list = true
--  end,
--})

local disallowed_trailing_chars = { ",", "{", "}", ".", "[", "]", "(", ";" }

---@param line string
---@return boolean
local function should_add_semicolon(line)
  local trimmed = vim.trim(line)
  if trimmed == "" then
    return false
  end
  local last_char = line:sub(-1)

  if vim.tbl_contains(disallowed_trailing_chars, last_char) then
    return false
  end

  return true
end

--- auto add semicolon at the end of line for specific filetypes
--- if semicolon exist, just create a new line
--- or add semicolon before creating a new line
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "rust" }, -- adjust to your desired filetypes
  callback = function()
    vim.keymap.set({ "n", "i" }, ";;", function()
      local line = vim.api.nvim_get_current_line()

      -- Add semicolon if not ending in {, (, [, . or already ends with ;
      if should_add_semicolon(line) then
        vim.api.nvim_set_current_line(line .. ";")
      end
      -- use <CR> in insert mode for keeping indent
      vim.cmd("startinsert!")
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
    end, { buffer = true, desc = "Add semicolon if needed and open new line" })
  end,
})

-- disable buggy anims in completion windows
-- sanck animate conflict with blink
auto_cmd("User", {
  group = myAutoGroup,
  pattern = "BlinkCmpMenuOpen",
  callback = function()
    vim.g.snacks_animate = false
  end,
})

auto_cmd("User", {
  group = myAutoGroup,
  pattern = "BlinkCmpMenuClose",
  callback = function()
    vim.g.snacks_animate = true
  end,
})

-- auto reload the buffer if the file is changed by other tools
auto_cmd({ "FocusGained", "BufEnter" }, {
  group = myAutoGroup,
  command = "checktime",
})

--cmd("BufLeave", {
--  pattern = "*",
--  callback = function()
--    if vim.bo.filetype == "aerial" then
--      vim.cmd("AerialClose")
--    end
--  end,
--})

-- 主动开启 treesitter
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "rust",
    "javascript",
    "c",
    "lua",
    "vim",
    "go",
    "toml",
    "vimdoc",
    "yaml",
    "bash",
    "sql",
    "proto",
    "css",
    "markdown",
    "json",
    "python",
  },
  callback = function()
    vim.treesitter.start()
  end,
})
