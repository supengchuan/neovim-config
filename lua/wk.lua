local wk = require("which-key")

local function get_visual()
	local _, ls, cs = unpack(vim.fn.getpos("v"))
	local _, le, ce = unpack(vim.fn.getpos("."))

	-- nvim_buf_get_text requires start and end args be in correct order
	ls, le = math.min(ls, le), math.max(ls, le)
	cs, ce = math.min(cs, ce), math.max(cs, ce)

	return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
end

-- Default options for opts
--{
--  mode = "n", -- NORMAL mode
--  -- prefix: use "<leader>f" for example for mapping everything related to finding files
--  -- the prefix is prepended to every mapping part of `mappings`
--  prefix = "",
--  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
--  silent = true, -- use `silent` when creating keymaps
--  noremap = true, -- use `noremap` when creating keymaps
--  nowait = false, -- use `nowait` when creating keymaps
--  expr = false, -- use `expr` when creating keymaps
--}

function Toggle_wrap()
	local id = vim.api.nvim_get_current_win()

	if vim.wo[id].wrap == true then
		vim.wo[id].wrap = false
	else
		vim.wo[id].wrap = true
	end
end

function Toggle_inlay_hints()
	if vim.lsp.inlay_hint.is_enabled({}) then
		vim.lsp.inlay_hint.enable(false)
		print("Disable inlay hints")
	else
		vim.lsp.inlay_hint.enable(true)
		print("Enable inlay hints")
	end
end

wk.register({
	["ff"] = {
		"<cmd>lua require('telescope.builtin').find_files()<CR>",
		"Find File",
	},
	j = { "5j", "move cursor down five lines" },
	k = { "5k", "move cursor up five lines" },
	p = { "<cmd>MarkdownPreviewToggle<CR>", "preview markdown" },
	w = { "<cmd>w<CR>", "save current buffer" },
	q = { "<cmd>q<CR>", "quit from current buffer" },
	["nl"] = { "<cmd>nohlsearch<CR>", "cancel highlight for search" },
	o = { "<cmd>AerialToggle<CR>", "list current buffer outlines" },
	["="] = { "<cmd>vertical resize +10<CR>", "current buffer wider" },
	["+"] = { "<cmd>vertical resize -10<CR>", "current buffer narrower" },
	i = { "<cmd>lua vim.diagnostic.open_float()<CR>", "open diagnostic as float window" },
	["d["] = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "go to previous diagnostic" },
	["d]"] = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "go to next diagnostic" },
	["dd"] = { "<cmd>Telescope diagnostics<CR>", "list diagnostics via telescope" },
	["rn"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "rename token" },
	e = {
		"<cmd>lua require('telescope.builtin').buffers()<CR>",
		"list open buffers",
	},
	["lg"] = {
		"<cmd>lua  require('telescope').extensions.live_grep_args.live_grep_args({initial_mode = 'insert'})<cr>",
		"live grep string",
	},
	["s"] = {
		"<cmd>lua require('telescope.builtin').grep_string({initial_mode = 'insert'})<cr>",
		"grep string",
	},
	["cs"] = {
		function(opts)
			opts = opts or {}
			local current_path = vim.fn.expand("%")
			opts["search_dirs"] = { current_path }
			local word_under_cursor = vim.fn.expand("<cword>")
			opts["default_text"] = word_under_cursor

			require("telescope").extensions.live_grep_args.live_grep_args(opts)
		end,
		"search the word under cursor in current buffer",
	},
	["im"] = {
		"<cmd>lua require('telescope').extensions.goimpl.goimpl{initial_mode='insert'}<CR>",
		"use goimpl to implement a interface fro struct",
	},
	-- dap
	["b"] = { "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", "set a breakpoint" },
	--["<Leader>B"] = { "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", "" },
	--["<Leader>lp"] = { "<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", "" },
	--["<Leader>dr"] = { "<Cmd>lua require'dap'.repl.open()<CR>", "" },
	--["<Leader>dl"] = { "<Cmd>lua require'dap'.run_last()<CR>", "" },

	["gr"] = { "<cmd>Gitsigns reset_hunk<CR>", "reset hunk" },
	["gs"] = { "<cmd>Gitsigns stage_hunk<CR>", "stage hunk" },
	["gb"] = { "<cmd>Gitsigns blame_line<CR>", "blame line" },
	["<CR>"] = { Toggle_wrap, "set file wrap or no wrap" },
	["h"] = { Toggle_inlay_hints, "set a buffer enable inlay hints or not" },
	["z"] = { "<cmd>lua require('zen-mode').toggle({window = {width = 0.85}})<cr>", "toggle zen mode" },
	["-"] = { "<cmd>lua require('oil').toggle_float()<cr>", "open parent dir with oil" },
}, { prefix = "<leader>" })

wk.register({
	["jj"] = { "<ESC>", "double j to normal mode" },
}, { mode = "i" })

wk.register({
	["cs"] = {
		function(opts)
			opts = opts or {}
			local current_path = vim.fn.expand("%")
			opts["search_dirs"] = { current_path }
			local visual = get_visual()
			local text = visual[1] or ""
			opts["default_text"] = text

			require("telescope").extensions.live_grep_args.live_grep_args(opts)
		end,
		"search a string in visual block in current buffer",
	},

	["s"] = {
		function(opts)
			opts = opts or {}
			local visual = get_visual()
			local text = visual[1] or ""
			opts["default_text"] = text

			require("telescope").extensions.live_grep_args.live_grep_args(opts)
		end,
		"search a string in visual block ",
	},
}, { mode = "x", prefix = "<leader>" })

wk.register({
	f = { name = "+format", f = { "<cmd>Format<CR>", "file format" } },
	g = {
		h = { "<cmd>lua vim.lsp.buf.hover()<CR>", "show lsp hint" },
		r = {
			"<cmd>lua require('telescope.builtin').lsp_references({layout_strategy= 'vertical', include_declaration = false, show_line = false})<CR>",
			"go to references",
		},
		i = {
			"<cmd>lua require('telescope.builtin').lsp_implementations({layout_strategy= 'vertical', include_declaration = false, show_line = false})<CR>",
			"go to implementations",
		},
	},
})

wk.register({
	["<C-n>"] = { "<cmd>NvimTreeToggle<CR>", "toggle folder tree on left" },
	["<C-h>"] = { "<cmd>NvimTmuxNavigateLeft<CR>", "move cursor to left window" },
	["<C-j>"] = { "<cmd>NvimTmuxNavigateDown<CR>", "move cursor to blow window" },
	["<C-k>"] = { "<cmd>NvimTmuxNavigateUp<CR>", "move cursor to up window" },
	["<C-l>"] = { "<cmd>NvimTmuxNavigateRight<CR>", "move cursor to right window" },
	["<C-]>"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "go to definition" },
	-- dap
	["F5"] = { "<cmd>lua require'dap'.continue()<CR>", "debug continue" },
	["F10"] = { "<cmd>lua require'dap'.step_over()<CR>", "debug step over" },
	["F11"] = { "<cmd>lua require'dap'.step_into()<CR>", "debug step into" },
	["F12"] = { "<cmd>lua require'dap'.step_out()<CR>", "debug step out" },
})
