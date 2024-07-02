return {
	"folke/noice.nvim",
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	},
	event = "VeryLazy",
	config = function()
		require("noice").setup({
			views = {
				cmdline_popup = {
					border = {
						style = "double",
						padding = { 2, 3 },
					},
					filter_options = {},
					win_options = {
						winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
					},
				},
			},
			cmdline = {
				view = "cmdline_popup",
				format = {
					search_down = {
						view = "cmdline",
					},
					search_up = {
						view = "cmdline",
					},
				},
			},
		})
		require("notify").setup({
			background_colour = "#000000",
		})
	end,
}
