local st_floattus, toggleterm = pcall(require, "toggleterm")
if not st_floattus then
	vim.notify("没有找到 toggleterm")
	return
end

local on_windows = vim.loop.os_uname().version:match("Windows")
if on_windows then
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
	-- size can be a number or function which is passed the current terminal
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.4
		end
	end,
	start_in_insert = true,
	shell = function()
		if on_windows then
			return "pwsh"
		else
			return vim.o.shell
		end
	end,
})

local Terminal = require("toggleterm.terminal").Terminal

local t_float = Terminal:new({
	-- direction = 'vertical' | 'horizontal' | 'tab' | 'float',
	direction = "float",
	float_opts = {
		-- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
		border = "curved",
	},
	close_on_exit = true,
})

local lazygit = Terminal:new({
	direction = "float",
	cmd = "lazygit",
	hidden = true,
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

M.lazygit_toggle = function(cmd)
	lazygit:toggle()
end

require("keybindings").mapToggleTerm(M)
