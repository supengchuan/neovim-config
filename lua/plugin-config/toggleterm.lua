local st_floattus, toggleterm = pcall(require, "toggleterm")
if not st_floattus then
	vim.notify("没有找到 toggleterm")
	return
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
