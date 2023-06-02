local status, nvim_tree = pcall(require, "nvim-tree")
if not status then
	vim.notify("没有找到 nvim-tree")
	return
end

local function open_nvim_tree(data)
	-- buffer is a [No Name]
	local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

	-- buffer is a directory
	local directory = vim.fn.isdirectory(data.file) == 1

	if not no_name and not directory then
		return
	end

	-- change to the directory
	if directory then
		vim.cmd.cd(data.file)
	end

	-- open the tree
	require("nvim-tree.api").tree.open()
end

--vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

require("nvim-web-devicons").setup({
	override = {
		dockerfile = {
			icon = "",
			color = "#458ee6",
			cterm_color = "68",
			name = "Dockerfile",
		},
	},
})

nvim_tree.setup({
	sort_by = "name",
	root_dirs = {},
	prefer_startup_root = true,
	sync_root_with_cwd = true,
	reload_on_bufenter = false,
	respect_buf_cwd = false,
	on_attach = "default",
	remove_keymaps = false,
	select_prompts = false,
	view = {
		centralize_selection = false,
		cursorline = true,
		debounce_delay = 15,
		width = 30,
		hide_root_folder = false,
		side = "left",
		preserve_window_proportions = false,
		number = false,
		relativenumber = false,
		signcolumn = "yes",
		float = {
			enable = false,
			quit_on_focus_loss = true,
			open_win_config = {
				relative = "editor",
				border = "rounded",
				width = 30,
				height = 30,
				row = 1,
				col = 1,
			},
		},
	},
	renderer = {
		add_trailing = false,
		group_empty = false,
		highlight_git = true,
		full_name = false,
		highlight_opened_files = "none",
		highlight_modified = "none",
		root_folder_label = ":~:s?$?/..?",
		indent_width = 2,
		indent_markers = {
			enable = false,
			inline_arrows = true,
			icons = {
				corner = "└",
				edge = "│",
				item = "│",
				bottom = "─",
				none = " ",
			},
		},
		icons = {
			webdev_colors = true,
			git_placement = "before",
			modified_placement = "after",
			padding = " ",
			symlink_arrow = " ➛ ",
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
				modified = true,
			},
			glyphs = {
				default = "",
				symlink = "",
				bookmark = "󰆤",
				modified = "●",
				folder = {
					arrow_closed = "",
					arrow_open = "",
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
				git = {
					unstaged = "✗",
					staged = "✓",
					unmerged = "",
					renamed = "➜",
					untracked = "★",
					deleted = "",
					ignored = "◌",
				},
			},
		},
		special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
		symlink_destination = true,
	},
	hijack_directories = {
		enable = true,
		auto_open = true,
	},
	system_open = {
		cmd = "",
		args = {},
	},
	diagnostics = {
		enable = false,
		show_on_dirs = false,
		show_on_open_dirs = true,
		debounce_delay = 50,
		severity = {
			min = vim.diagnostic.severity.HINT,
			max = vim.diagnostic.severity.ERROR,
		},
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	filesystem_watchers = {
		enable = true,
		debounce_delay = 50,
		ignore_dirs = {},
	},
	git = {
		enable = true,
		ignore = true,
		show_on_dirs = true,
		show_on_open_dirs = true,
		timeout = 400,
	},
	modified = {
		enable = false,
		show_on_dirs = true,
		show_on_open_dirs = true,
	},
	actions = {
		use_system_clipboard = true,
		change_dir = {
			enable = true,
			global = false,
			restrict_above_cwd = false,
		},
		expand_all = {
			max_folder_discovery = 300,
			exclude = {},
		},
		file_popup = {
			open_win_config = {
				col = 1,
				row = 1,
				relative = "cursor",
				border = "shadow",
				style = "minimal",
			},
		},
		open_file = {
			quit_on_open = false,
			resize_window = true,
			window_picker = {
				enable = true,
				picker = "default",
				chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
				exclude = {
					filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
					buftype = { "nofile", "terminal", "help" },
				},
			},
		},
		remove_file = {
			close_window = true,
		},
	},
})
