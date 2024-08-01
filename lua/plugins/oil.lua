return {
	"stevearc/oil.nvim",
	opts = {
		view_options = {
			show_hidden = true,
		},
		-- Configuration for the floating window in oil.open_float
		float = {
			-- Padding around the floating window
			padding = 5,
		},
		keymaps = {
			["<2-LeftMouse>"] = "actions.select",
		},
	},

	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
