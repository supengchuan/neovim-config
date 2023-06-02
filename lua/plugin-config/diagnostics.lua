local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
	virtual_text = {
		source = "always", -- Or "if_many"
		prefix = "●", -- Could be '■', '▎', 'x'
		spacing = 20,
	},
	signs = true,
	severity_sort = true,
	float = {
		source = "always", -- Or "if_many"
		border = "double",
	},
})
require("lspconfig.ui.windows").default_options.border = "double"
