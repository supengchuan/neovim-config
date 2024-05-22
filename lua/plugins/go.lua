local M = {
	"ray-x/go.nvim",
	dependencies = { -- optional packages
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		-- set config
		local lsp_common = require("lsp-config.common")
		require("go").setup({
			tag_transform = "camelcase",
			lsp_cfg = {
				capabilities = lsp_common.capabilities,
				-- other setups

				handlers = lsp_common.handlers,
				on_attach = function(client, bufnr)
					lsp_common.keyAttach(bufnr)
					if client.server_capabilities.inlayHintProvider then
						vim.lsp.inlay_hint.enable(true)
					end
				end,
			},
			lsp_inlay_hints = {
				enable = false,
			},

			lsp_keymaps = false,
			comment_placeholder = "  ",
		})
	end,
	--event = { "CmdlineEnter" },
	ft = { "go", "gomod" },
	build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
}

return M
