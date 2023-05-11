vim.o.background = "dark"

local colorscheme = ""

-- override Dracula background color
require("dracula").setup({
	colors = {
		bg = "#1e1f29",
	},
})

colorscheme = "dracula"
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	vim.notify("colorscheme: " .. colorscheme .. " 没有找到！")
	return
end
