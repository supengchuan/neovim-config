local M = {
	"loctvl842/monokai-pro.nvim",
	config = function()
		require("monokai-pro").setup({
			filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
		})
	end,
}

return M
