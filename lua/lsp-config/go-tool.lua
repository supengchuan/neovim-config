local lsp_common = require("lsp-config.common")
require("go").setup({
	tag_transform = "camelcase",
	lsp_cfg = {
		capabilities = lsp_common.capabilities,
		-- other setups

		handlers = lsp_common.handlers,
		on_attach = function(client, bufnr)
			lsp_common.keyAttach(bufnr)
		end,
	},
	lsp_diag_underline = false,
	lsp_inlay_hints = {
		only_current_line = true,
	},

	lsp_keymaps = false,
})
