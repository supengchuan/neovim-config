local status, bufferline = pcall(require, "bufferline")
if not status then
	vim.notify("没有找到 bufferline")
	return
end
-- bfferline 配置
-- https://github.com/akinsho/bufferline.nvim#configuration
bufferline.setup({
	options = {
		middle_mouse_command = function()
			require("bufferline").sort_buffers_by(function(buf_a, buf_b)
				return buf_a.id < buf_b.id
			end)
		end,
		mode = "buffers",
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
			-- -- current buffer don't show LSP indicators
			-- if context.buffer:current() then
			--     return ''
			-- end
			local s = " "
			-- e=level,n=count
			for e, n in pairs(diagnostics_dict) do
				-- sym  symbol的缩写
				local sym = e == "error" and " " or (e == "warning" and " " or "")
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
		--		offsets = {
		--			{
		--				filetype = "NvimTree",
		--				text = "File Explorer",
		--				highlight = "Directory",
		--				separator = true,
		--			},
		--		},
		buffer_close_icon = "",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",
		separator_style = "thin",
		show_buffer_close_icon = true,
		show_close_icon = false,
		--		middle_mouse_command = function(bufnum)
		--			require("bufdelete").bufdelete(bufnum, true)
		--		end,
		right_mouse_command = "vertical sbuffer %d",
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,
	},
})
