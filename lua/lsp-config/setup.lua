-- Setup lspconfig.

local lspconfig
status, lspconfig = pcall(require, "lspconfig")
if not status then
	vim.notify("没有找到 lspconfig")
	return
end

local servers = {
	--	clangd = require("lsp-config.servers.clangd"),
	ccls = require("lsp-config.servers.ccls"),
	gopls = require("lsp-config.servers.gopls"),
	sumneko_lua = require("lsp-config.servers.lua"),
	pyright = require("lsp-config.servers.pyright"),
	sqls = require("lsp-config.servers.sqls"),
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
