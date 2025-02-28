local myAutoGroup = vim.api.nvim_create_augroup("myAutoGroup", {
  clear = true,
})

local autocmd = vim.api.nvim_create_autocmd

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
autocmd("TermOpen", {
  group = myAutoGroup,
  command = "startinsert",
})

-- 自动保存
autocmd({ "InsertLeave", "TextChanged" }, {
  group = myAutoGroup,
  pattern = { "*" },
  command = "silent! wall",
})

-- 保存时自动格式化
autocmd("BufWritePre", {
  group = myAutoGroup,
  pattern = { "*.lua", "*.py", "*.go", "*.rs", "*.md" },
  --	callback = vim.lsp.buf.formatting_sync,
  command = "Format",
})

autocmd("BufWritePre", {
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
autocmd("BufEnter", {
  group = myAutoGroup,
  pattern = "*",
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions
      - "o" -- O and o, don't continue comments
      + "r" -- But do continue when pressing enter.
  end,
})

-- set rust file space chars
autocmd("BufEnter", {
  group = myAutoGroup,
  pattern = "*.rs",
  callback = function()
    -- only for current buffer
    vim.wo.listchars = "eol:\\u21b5,leadmultispace: ,space:.,tab:>-,trail:-"
  end,
})

-- reopen file in the same position
autocmd("BufReadPost", {
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
autocmd("BufEnter", {
  pattern = { "*.md", "*.tex" },
  group = myAutoGroup,
  callback = function()
    vim.wo.colorcolumn = ""
    vim.wo.wrap = true
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

-- set tab as 2 space for lua file
autocmd("BufEnter", {
  pattern = { "*.lua" },
  group = myAutoGroup,
  callback = function()
    vim.o.shiftwidth = 2
    vim.o.expandtab = true
  end,
})

-- Turn off syntax highlighting for large files
autocmd("BufEnter", {
  group = myAutoGroup,
  pattern = "*",
  callback = function()
    if vim.api.nvim_buf_line_count(0) > 20000 then
      vim.cmd([[ syntax off ]])
    end
  end,
})

vim.api.nvim_create_user_command("CompareWith", function()
  require("telescope").extensions.diff.diff_current({ hidden = true })
end, {})

vim.api.nvim_create_user_command("Compare", function()
  require("telescope").extensions.diff.diff_files({ hidden = true })
end, {})

vim.api.nvim_create_user_command("CWD", function()
  local current_buffer_dir = vim.fn.expand("%:p:h")
  vim.api.nvim_set_current_dir(current_buffer_dir)
end, {})

-- set <C-]> to jump to tag in nvim help document
-- because I mapped lsp_definition to <C-]>, it cannot jump to tag in nvim help documents
autocmd({ "FileType" }, {
  pattern = { "help" },
  callback = function(opts)
    vim.keymap.set("n", "<C-]>", "<C-]>", { silent = true, buffer = opts.buf })
  end,
})

-- add line number for telescope preview
autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function()
    vim.cmd([[setlocal number]])
  end,
})
