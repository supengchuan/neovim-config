local myAutoGroup = vim.api.nvim_create_augroup("LocalGroup", {
  clear = true,
})

local cmd = vim.api.nvim_create_autocmd

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
cmd("TermOpen", {
  group = myAutoGroup,
  command = "startinsert",
})

-- 自动保存
cmd({ "InsertLeave", "TextChanged" }, {
  group = myAutoGroup,
  pattern = { "*" },
  command = "silent! wall",
})

-- 保存时自动格式化
cmd("BufWritePre", {
  group = myAutoGroup,
  pattern = { "*.lua", "*.py", "*.go", "*.rs", "*.md" },
  --	callback = vim.lsp.buf.formatting_sync,
  command = "Format",
})

cmd("BufWritePre", {
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
cmd("BufEnter", {
  group = myAutoGroup,
  pattern = "*",
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions
      - "o" -- O and o, don't continue comments
      + "r" -- But do continue when pressing enter.
  end,
})

-- set rust file space chars
cmd("BufEnter", {
  group = myAutoGroup,
  pattern = "*.rs",
  callback = function()
    -- only for current buffer
    vim.wo.listchars = "eol:\\u21b5,leadmultispace: ,space:.,tab:>-,trail:-"
  end,
})

-- reopen file in the same position
cmd("BufReadPost", {
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
cmd("BufEnter", {
  pattern = { "*.md", "*.tex" },
  group = myAutoGroup,
  callback = function()
    vim.opt_local.colorcolumn = ""
    vim.opt_local.wrap = true
    local map = vim.keymap.set
    map("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
    map("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
    vim.api.nvim_echo({ { "gj, gk mode" } }, false, {})
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
cmd("BufEnter", {
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
cmd({ "FileType" }, {
  pattern = { "help" },
  callback = function(opts)
    vim.keymap.set("n", "<C-]>", "<C-]>", { silent = true, buffer = opts.buf })
  end,
})

-- add line number for telescope preview
cmd("User", {
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
    vim.keymap.set("n", "o", function()
      local line = vim.api.nvim_get_current_line()

      -- Add semicolon if not ending in {, (, [, . or already ends with ;
      if should_add_semicolon(line) then
        vim.api.nvim_set_current_line(line .. ";")
      end
      -- use <CR> in insert mode for keeping indent
      vim.cmd("startinsert!")
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
    end, { buffer = true })
  end,
})

-- disable buggy anims in completion windows
-- sanck animate conflict with blink
cmd("User", {
  group = myAutoGroup,
  pattern = "BlinkCmpMenuOpen",
  callback = function()
    vim.g.snacks_animate = false
  end,
})

cmd("User", {
  group = myAutoGroup,
  pattern = "BlinkCmpMenuClose",
  callback = function()
    vim.g.snacks_animate = true
  end,
})
