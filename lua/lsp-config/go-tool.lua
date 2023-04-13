local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
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
	lsp_inlay_hints = {
		only_current_line = true,
	},

	lsp_keymaps = false,
})
