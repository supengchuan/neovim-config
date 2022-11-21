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
