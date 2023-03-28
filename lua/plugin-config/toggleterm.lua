local on_windows = vim.loop.os_uname().version:match("Windows")
local st_floattus, toggleterm = pcall(require, "toggleterm")
if not st_floattus then
	vim.notify("没有找到 toggleterm")
	return
elseif on_windows then
	-- use pwsh on windows
	vim.opt.shell = vim.fn.executable("pwsh") and "pwsh" or "powershell"
	vim.opt.shellcmdflag =
		"-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
	vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
	vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
	vim.opt.shellquote = ""
	vim.opt.shellxquote = ""
end

toggleterm.setup({
	size = function(term)
		if term.direction == "horizont_floatl" then
			return 10
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.3
		end
	end,
	st_floatrt_in_insert = true,
})

local Terminal = require("toggleterm.terminal").Terminal

local t_float = Terminal:new({
	direction = "float",
	float_opts = {
		border = "double",
	},
	close_on_exit = true,
})

local M = {}

M.toggle = function(cmd)
	if t_float:is_open() then
		t_float:close()
		return
	end
	t_float:open()
	if cmd ~= nil then
		t_float:send(cmd)
	end
end

require("keybindings").mapToggleTerm(M)
