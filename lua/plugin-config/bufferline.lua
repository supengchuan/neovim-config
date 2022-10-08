vim.opt.termguicolors = true

require("bufferline").setup({
	options = {
		mode = "buffers",
		numbers = "none",
		tab_size = 10,
		hover = {
			enbaled = true,
			delay = 200,
			reveal = { "close" },
		},
		indicator = {
			--icon = " ",
			icon = "  ",
			style = "icon",
		},
		modified_icon = "●",
		-- 使用 nvim 内置lsp
		diagnostics = "nvim_lsp",
		-- 左侧让出 nvim-tree 的位置
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				highlight = "Directory",
				separator = true,
			},
		},
		buffer_close_icon = "",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",
		separator_style = "thin",
		show_buffer_close_icon = false,
		show_close_icon = false,
		left_mouse_command = function(bufnum)
			require("bufdelete").bufdelete(bufnum, true)
		end,
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,
	},
})
