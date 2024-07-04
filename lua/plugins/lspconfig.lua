local M = {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- lspkind adds vscode-like pictograms to neovim built-in lsp
		"onsails/lspkind-nvim",
	},
	config = function()
		-- Setup lspconfig.
		local status, lspconfig = pcall(require, "lspconfig")
		if not status then
			vim.notify("没有找到 lspconfig")
			return
		end

		local servers = {
			clangd = require("lsp-config.servers.clangd"),
			--ccls = require("lsp-config.servers.ccls"),
			nginx_language_server = require("lsp-config.servers.nginx-language-server"),
			lua_ls = require("lsp-config.servers.lua"),
			pyright = require("lsp-config.servers.pyright"),
			sqlls = require("lsp-config.servers.sqls"),
			bashls = require("lsp-config.servers.bashls"),
			bufls = require("lsp-config.servers.bufls"),
		}

		for name, config in pairs(servers) do
			if config ~= nil and type(config) == "table" then
				-- 自定义初始化配置文件必须实现on_setup 方法
				config.on_setup(lspconfig[name])
			else
				-- 使用默认参数
				lspconfig[name].setup({})
			end
		end
	end,
}
return M
