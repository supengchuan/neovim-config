local function ensure_lazy()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)
end
ensure_lazy()

-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

local lazy = require("lazy")

local plugins = {
	-- color theme
	require("plugins.tokyonight"),
	require("plugins.catppuccin"),

	-- nvim tree
	require("plugins.nvim-tree"),
	require("plugins.tree-sitter"),
	-- Collection of configurations for the built-in LSP client
	require("plugins.lspconfig"),
	-- nvim-cmp
	{
		"hrsh7th/nvim-cmp",
		lazy = false,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", --nvim-cmp source for neovim's built-in language server client.
			"hrsh7th/cmp-nvim-lua", -- nvim-cmp source for neovim Lua API.
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
		},
	},
	-- vsnip
	"rafamadriz/friendly-snippets",
	-- lspkind adds vscode-like pictograms to neovim built-in lsp
	"onsails/lspkind-nvim",

	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",

	-- bufferline
	require("plugins.bufferline"),

	-- no usage
	--{ "famiu/bufdelete.nvim", event = "VimEnter" },
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {}, -- this is equalent to setup({}) function
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	require("plugins.lualine"),

	-- for git
	"tpope/vim-fugitive",
	require("plugins.gitsigns"),

	-- rust  To enable more of the features of rust-analyzer, such as inlay hints and more!
	require("plugins.rust"),
	-- format
	"mhartington/formatter.nvim",
	-- outline
	require("plugins.aerial"),

	-- float termnial
	require("plugins.toggleterm"),

	-- telescope
	require("plugins.telescope"),
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("dashboard").setup({
				-- config
			})
		end,
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- color
	require("plugins.nvim-colorizer"),

	--debug
	"mfussenegger/nvim-dap",
	"leoluz/nvim-dap-go",
	"theHamsta/nvim-dap-virtual-text",
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	},

	-- golang tool
	require("plugins.go"),

	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	-- markdown
	-- install without yarn or npm
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	-- key map
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	-- indent
	require("plugins.indent_blankline"),
	-- package manager
	require("plugins.mason"),

	-- latex
	{ "lervag/vimtex", event = "VeryLazy" },

	-- jump
	--"ggandor/leap.nvim",
	require("plugins.leap"),

	-- float input
	{ "liangxianzhe/floating-input.nvim" },
	-- 显示一些信息在角落
	require("plugins.fidget"),
	-- cmake tools
	require("plugins.cmake_tools"),
	require("plugins.nvim-tmux-navigation"),
}

local opts = {
	defaults = {
		lazy = false,
	},
	ui = {
		border = "single",
	},
}

lazy.setup(plugins, opts)
