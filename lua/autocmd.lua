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
		vim.o.wrap = true
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
autocmd("BufEnter", {
	group = myAutoGroup,
	pattern = "*",
	callback = function()
		if vim.api.nvim_buf_line_count(0) > 20000 then
			vim.cmd([[ syntax off ]])
		end
	end,
})
