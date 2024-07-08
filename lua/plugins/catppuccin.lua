local M = {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "macchiato", -- latte, frappe, macchiato, mocha
			transparent_background = false, -- disables setting the background color.
			no_underline = true, -- Force no underline
			term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
			dim_inactive = {
				enabled = false, -- dims the background color of inactive window
				shade = "dark",
				percentage = 0.9, -- percentage of the shade to apply to the inactive window
			},

			styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
				comments = { "italic" }, -- Change the style of comments
				conditionals = { "italic" },
				loops = {},
				functions = {},
				keywords = { "bold" },
				strings = { "italic" },
				variables = {},
				numbers = { "bold" },
				booleans = {},
				properties = {},
				types = {},
				operators = { "bold" },
			},

			integrations = {
				bufferline = true,
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				notify = false,
				mini = {
					enabled = true,
					indentscope_color = "",
				},
				leap = false, -- only set bg transparent can make this enabled
				aerial = true,
			},
			-- disable overide color for comments
			custom_highlights = function(colors)
				return {
					LeapBackdrop = { fg = colors.overlay0 },
				}
			end,
		})
	end,
}

return M
