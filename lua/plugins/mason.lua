local M = {
	"williamboman/mason.nvim",
	event = "VimEnter",
	config = {
		ui = {
			border = "double",
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	},
}

return M
