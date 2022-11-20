-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local opts = {
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "Lua 5.3.6",
				-- Setup your lua path
				path = {
					"~/.config/init.lua",
					"?.lua",
					"?/init.lua",
					vim.fn.expand("~/.luarocks/share/lua/5.3/?.lua"),
					vim.fn.expand("~/.luarocks/share/lua/5.3/?/init.lua"),
					"/usr/share/5.3/?.lua",
					"/usr/share/lua/5.3/?/init.lua",
				},
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
	capabilities = require("lsp-config.common").capabilities,
	on_attach = function(client, bufnr)
		local lspComm = require("lsp-config.common")
		lspComm.keyAttach(bufnr)
		lspComm.disableFormat(client)
		lspComm.shwLinDiaAtom(bufnr)
		-- lspComm.hlSymUdrCursor(client, bufnr)
	end,
	handlers = require("lsp-config.common").handlers,
}

return {
	on_setup = function(server)
		server.setup(opts)
	end,
}
