local M = {
	"mrcjkb/rustaceanvim",
	version = "^4", -- Recommended
	ft = { "rust" },
	config = function()
		vim.g.rustaceanvim = {
			tools = {
				hover_actions = {
					auto_focus = true,
				},
			},
			server = {
				settings = {
					-- rust-analyzer language server configuration
					["rust-analyzer"] = {},
				},
			},
		}
	end,
}
return M
