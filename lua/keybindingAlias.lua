local M = {

	-- Modes
	--   normal_mode = "n",
	--   insert_mode = "i",
	--   visual_mode = "v",
	--   visual_block_mode = "x",
	--   term_mode = "t",
	--   command_mode = "c",
	--   select_mode = "s"

	-- normal模式下键盘映射
	norl = {
		-- 前导键
		leader_key = " ",
		goto_command_mode = "<F1>",

		go_left35 = "H",
		go_right35 = "L",
		go_up_10line = "<leader>k",
		go_down_10line = "<leader>j",

		-- save exit and exit all
		quit_window = "<Leader>q",
		save_window = "<Leader>w",
	},
	-- insert 模式下键盘映射
	insert = {
		goto_command_mode = "<F1>",
	},
	--插件键位映射
	nvimTree = {
		NvimTreeToggle = "<C-n>",
	},

	bufferline = {
		BufferLineCyclePrev = "<Leader>h",
		BufferLineCycleNext = "<Leader>l",
		BufferLinePick = "<Leader>p",
		BufferLinePickClose = "<Leader>c",
		ToBuffer1 = "<leader>1",
		ToBuffer2 = "<leader>2",
		ToBuffer3 = "<leader>3",
		ToBuffer4 = "<leader>4",
		ToBuffer5 = "<leader>5",
		ToBuffer6 = "<leader>6",
		ToBuffer7 = "<leader>7",
	},

	dap = {
		debugg = "<F5>",
		debugg_step_over = "<F6>",
		debugg_end = "<space>w",
		clear_breakpoints = "<space>T",
		toggle_breakpoint = "<space>t",
		-- dapUI
		eval_expression = "<space>h",
		eval_expression_visual = "<Leader><Leader>",
	},
	toggerterm = {
		open_float = "<leader>t",
		hide = "<C-t>",
	},
	gitsigns = {
		gs_next_hunk = "<leader>gj",
		gs_pre_hunk = "<leader>gk",
		stage_hunk = "<leader>gs",
		reset_hunk = "<leader>gr",
		stage_buffer = "<leader>gS",
		undo_stage_hunk = "<leader>gu",
		reset_buffer = "<leader>gR",
		preview_hunk = "<leader>gp",
		blame_line = "<leader>gb",
		diffthis = "<leader>gd",
		diffthiss = "<leader>gD",
		toggle_current_line_blame = "<leader>gtb",
		toggle_deleted = "<leader>gtd",
		select_hunk = "ig",
	},
}

return M
