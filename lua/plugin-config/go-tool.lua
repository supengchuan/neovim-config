local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
require("go").setup({
	tag_transform = "camelcase",
	lsp_cfg = {
		capabilities = capabilities,
		-- other setups
	},
	lsp_inlay_hints = {
		only_current_line = true,
	},

	lsp_keymaps = false,
})
