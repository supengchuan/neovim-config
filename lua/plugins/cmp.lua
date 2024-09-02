local M = {
	"hrsh7th/nvim-cmp",
	lazy = false,
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", --nvim-cmp source for neovim's built-in language server client.
		"hrsh7th/cmp-nvim-lua", -- nvim-cmp source for neovim Lua API.
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp-signature-help",
	},
	config = function()
		local cmp = require("cmp")
		-- UI
		local kind_icons = require("icons")

		-- Setup nvim-cmp.
		cmp.setup({
			view = {
				docs = { auto_open = true },
			},
			formatting = {
				format = function(entry, vim_item)
					local lspkind_ok, lspkind = pcall(require, "lspkind")
					if not lspkind_ok then
						-- From kind_icons array
						vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
						-- Source
						vim_item.menu = ({
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							luasnip = "[LuaSnip]",
							nvim_lua = "[Lua]",
							latex_symbols = "[LaTeX]",
						})[entry.source.name]
						return vim_item
					else
						-- From lspkind
						return lspkind.cmp_format()(entry, vim_item)
					end
				end,
			},
			-- do not enable auto-completion in comments
			--enabled = function()
			--	-- disable completion in comments
			--	local context = require("cmp.config.context")
			--	-- keep command mode completion enabled when cursor is in a comment
			--	if vim.api.nvim_get_mode().mode == "c" then
			--		return true
			--	else
			--		return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
			--		-- return not context.in_syntax_group("Comment")
			--	end
			--end,

			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			window = {
				completion = cmp.config.window.bordered({
					border = "rounded",
					scrollbar = false,
				}),
				documentation = cmp.config.window.bordered({
					border = "rounded",
				}),
			},

			mapping = cmp.mapping.preset.insert({
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<tab>"] = cmp.config.disable,
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			}),

			sources = cmp.config.sources({
				{ name = "nvim_lua" },
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

			experimental = {
				-- I like the new menu better! Nice work hrsh7th
				native_menu = false,

				-- Let's play with this for a day or two
				ghost_text = false,
			},
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

		-- If you want insert `(` after select function or method item
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

		-- create a command to toggle auto open documentation for cmp
		vim.api.nvim_create_user_command("CmpToggleDoc", function()
			if cmp.visible_docs() then
				cmp.close_docs()
			else
				cmp.open_docs()
			end
		end, {})
	end,
}

return M
