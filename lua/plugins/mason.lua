local M = {
	"williamboman/mason.nvim",
	--	dependencies = { "williamboman/mason-lspconfig.nvim" },
	event = "VimEnter",
	config = function()
		require("mason").setup({
			ui = {
				border = "single",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		local registry = require("mason-registry")
		local others = {
			-- lsp
			"bash-language-server",
			-- "clangd",
			--"gopls",
			"lua-language-server",
			"nginx-language-server",
			"buf-language-server",

			-- formatter
			"stylua",
			"goimports",
			"shfmt",
			"taplo",
			"prettier",
			"sql-formatter",

			-- linter
			"shellcheck",
		}

		for _, pkg_name in ipairs(others) do
			local ok, pkg = pcall(registry.get_package, pkg_name)
			if ok then
				if not pkg:is_installed() then
					pkg:install()
				end
			end
		end
	end,
}
return M
