local status, cmp = pcall(require, "cmp")
if not status then
	vim.notify("没有找到 cmp")
	return
end

local luasnip
status, luasnip = pcall(require, "luasnip")
if not status then
	vim.notify("没有找到 luasnip")
	return
end

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local unlinkgrp = vim.api.nvim_create_augroup("UnlinkSnippetOnModeChange", { clear = true })
vim.api.nvim_create_autocmd("ModeChanged", {
	group = unlinkgrp,
	pattern = { "s:n", "i:*" },
	desc = "Forget the current snippet when leaving the insert mode",
	callback = function(evt)
		if luasnip.session and luasnip.session.current_nodes[evt.buf] and not luasnip.session.jump_active then
			luasnip.unlink_current()
		end
	end,
})

-- use friendly snip
require("luasnip/loaders/from_vscode").lazy_load()

-- UI
local kind_icons = {
	Text = "",
	Method = "",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "ﴯ",
	Interface = "",
	Module = "",
	Property = "ﰠ",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}

-- Setup nvim-cmp.
cmp.setup({
	formatting = {
		format = function(entry, vim_item)
			-- Kind icons
			vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
			-- Source
			vim_item.menu = ({
				buffer = "[Buffer]",
				nvim_lsp = "[LSP]",
				luasnip = "[LuaSnip]",
				dap = "[DAP]",
			})[entry.source.name]
			return vim_item
		end,
	},
	-- do not enable auto-completion in comments
	enabled = function()
		-- disable completion in comments
		local context = require("cmp.config.context")
		-- keep command mode completion enabled when cursor is in a comment
		if vim.api.nvim_get_mode().mode == "c" then
			return true
		else
			return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
			-- return not context.in_syntax_group("Comment")
		end
	end,

	window = {
		-- 使用这个有背景不一致的问题
		--completion = cmp.config.window.bordered(),
		--documentation = cmp.config.window.bordered(),
	},
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},

	mapping = cmp.mapping.preset.insert({
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		--	["<C-b>"] = cmp.mapping.scroll_docs(-4),
		--	["<C-f>"] = cmp.mapping.scroll_docs(4),
		--	["<C-Space>"] = cmp.mapping.complete(),
		--	["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),

	sources = cmp.config.sources({
		{ name = "nvim_lsp", group_index = 1 },
		{ name = "luasnip", group_index = 1 }, -- For luasnip users.
		{ name = "nvim_lsp_signature_help", group_index = 1 },
		{
			name = "buffer",
			option = {
				get_bufnrs = function()
					local buf = vim.api.nvim_get_current_buf()
					local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
					if byte_size > 1024 * 1024 then -- 1 Megabyte max
						return {}
					end
					return { buf }
				end,
			},
			group_index = 2,
		},
		{ name = "path", group_index = 2 },
	}),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = "buffer" },
	}),
})

cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{
			name = "buffer",
			option = {
				get_bufnrs = function()
					local buf = vim.api.nvim_get_current_buf()
					local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
					if byte_size > 1024 * 1024 then -- 1 Megabyte max
						return {}
					end
					return { buf }
				end,
			},
		},
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		-- https://github.com/hrsh7th/cmp-cmdline/issues/24
		-- https://github.com/hrsh7th/nvim-cmp/issues/821
		-- Solve the problem that typing :! in command mode takes too long time for wait  ENV:WSL2
		-- { name = 'cmdline', keyword_pattern = [[\!\@<!\w*]] }
		{ name = "cmdline" },
	}),
})
