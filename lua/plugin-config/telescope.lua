local status, telescope = pcall(require, "telescope")
if not status then
	vim.notify("没有找到 telescope")
	return
end

telescope.setup({
	defaults = {
		--prompt_prefix = "",
		-- 打开弹窗后进入的初始模式，默认为 normal，也可以是 insert
		initial_mode = "normal",

		layout_strategy = "vertical",
		layout_config = {
			height = 0.95,
			width = 0.75,
		},

		mappings = {
			n = {
				["q"] = "close",
				["<c-d>"] = require("telescope.actions").delete_buffer,
			},
		},
	},
	pickers = {
		buffers = {
			ignore_current_buffer = false,
			sort_lastused = true,
		},
	},
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
	},
})

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
pcall(telescope.load_extension, "fzf")
-- extension telescope-env.nvim
pcall(telescope.load_extension, "env")
-- extension telescope-project
pcall(telescope.load_extension, "projects")
-- extension telescope-dap
pcall(telescope.load_extension, "dap")
