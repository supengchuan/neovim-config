local myBufferlineHighlight = {}

local M = {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local bufferline = require("bufferline")
		bufferline.setup({
			options = {
				mode = "buffers",
				themable = false,
				middle_mouse_command = function()
					require("bufferline").sort_by(function(buf_a, buf_b)
						return buf_a.id < buf_b.id
					end)
				end,
				show_buffer_icons = true,
				numbers = "none",
				tab_size = 10,
				hover = {
					enbaled = true,
					delay = 200,
					reveal = { "close" },
				},
				indicator = {
					icon = "  ",
					style = "icon",
				},
				modified_icon = "●",
				-- 使用 nvim 内置lsp
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					-- current buffer don't show LSP indicators
					if context.buffer:current() then
						return ""
					end
					local s = " "
					-- e=level,n=count
					for e, n in pairs(diagnostics_dict) do
						-- sym  symbol的缩写
						local sym = e == "error" and " " or (e == "warning" and " " or " ")
						s = s .. n .. sym
					end
					return s
				end,
				-- 左侧让出 nvim-tree 的位置

				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						highlight = "Directory",
						text_align = "left",
					},
					{
						filetype = "lspsagaoutline",
						text = "👾outline",
						text_align = "right",
					},
				},
				color_icons = true,
				buffer_close_icon = "",
				close_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",
				-- slant padded_slant slope padded_slope thick thin
				separator_style = "thin",
				show_buffer_close_icon = true,
				show_close_icon = true,
				auto_toggle_bufferline = true,
				show_tab_indicators = true,
				right_mouse_command = "vertical sbuffer %d",
			},
		})
	end,
}

return M
