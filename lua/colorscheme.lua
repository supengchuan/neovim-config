vim.o.background = "dark"

local colorscheme = ""

colorscheme = "gruvbox"
colorscheme = "dracula"
colorscheme = "tokyonight"
colorscheme = "catppuccin"

if colorscheme == "tokyonight" then
	require("theme-config.tokyonight")
end

if colorscheme == "catppuccin" then
	require("theme-config.catppuccin")
end

if colorscheme == "dracula" then
	require("theme-config.dracula")
end

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	vim.notify("colorscheme: " .. colorscheme .. " 没有找到！")
	return
end
