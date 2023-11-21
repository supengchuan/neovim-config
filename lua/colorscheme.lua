vim.o.background = "dark"

local colorscheme = ""

-- override Dracula background color
require("dracula").setup({
	colors = {
		bg = "#1e1f29",
	},
})

colorscheme = "dracula"

colorscheme = "gruvbox"
colorscheme = "catppuccin-frappe"
colorscheme = "tokyonight-moon"

local prefix = "tokyonight"
if string.sub(colorscheme, 1, #prefix) == prefix then
	require("tokyonight").setup({
		transparent = true, -- Enable this to disable setting the background colors
		styles = {
			-- Style to be applied to different syntax groups
			-- Value is any valid attr-list value for `:help nvim_set_hl`
			comments = { italic = true },
			keywords = { italic = true },
			functions = {},
			variables = {},
			-- Background styles. Can be "dark", "transparent" or "normal"
			sidebars = "transparent", -- style for sidebars, see below
			floats = "transparent", -- style for floating windows
		},
	})
end

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	vim.notify("colorscheme: " .. colorscheme .. " 没有找到！")
	return
end
