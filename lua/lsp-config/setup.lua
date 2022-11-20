-- Setup lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

local lspconfig
status, lspconfig = pcall(require, "lspconfig")
if not status then
	vim.notify("没有找到 lspconfig")
	return
end

local servers = {
	sumneko_lua = require("lsp-config.servers.lua"), --/lua/lsp-config/servers/
	clangd = require("lsp-config.servers.clangd"),
	gopls = require("lsp-config.servers.gopls"),
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
