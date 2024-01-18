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
	"Mofiqul/dracula.nvim",
	"neanias/everforest-nvim",
	"marko-cerovac/material.nvim",
	"ellisonleao/gruvbox.nvim",
	"folke/tokyonight.nvim",
	"cpea2506/one_monokai.nvim",
	{ "rose-pine/neovim", name = "rose-pine" },
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "olimorris/onedarkpro.nvim", priority = 1000 },

	-- nvim tree
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = "nvim-tree/nvim-web-devicons",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},
	-- Collection of configurations for the built-in LSP client
	"neovim/nvim-lspconfig",
	-- nvim-cmp
	{
		"hrsh7th/nvim-cmp",
		version = "*",
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
	{
		"akinsho/bufferline.nvim",
		event = "VimEnter",
		dependencies = "nvim-tree/nvim-web-devicons",
	},
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
	"arkav/lualine-lsp-progress",
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
	},

	-- for git
	"tpope/vim-fugitive",
	"lewis6991/gitsigns.nvim",

	-- rust  To enable more of the features of rust-analyzer, such as inlay hints and more!
	{
		"mrcjkb/rustaceanvim",
		version = "^3", -- Recommended
		ft = { "rust" },
	},
	--"simrat39/rust-tools.nvim", --archived
	--"rust-lang/rust.vim",

	-- format
	"mhartington/formatter.nvim",
	-- outline
	"stevearc/aerial.nvim",

	-- float termnial
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
	},
	-- telescope
	{
		"nvim-telescope/telescope.nvim",
		version = "0.1.4",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	-- improve telescope performance
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	-- look environment variables with telescope
	"LinArcX/telescope-env.nvim",
	-- Project need
	"nvim-telescope/telescope-project.nvim",
	-- telesocpe-dap
	"nvim-telescope/telescope-dap.nvim",
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

	-- git graph
	"rbong/vim-flog",
	-- color
	"norcalli/nvim-colorizer.lua",

	--debug
	"mfussenegger/nvim-dap",
	"leoluz/nvim-dap-go",
	"theHamsta/nvim-dap-virtual-text",
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap" },
	},

	-- golang tool
	"ray-x/go.nvim",
	"ray-x/guihua.lua", -- recommended if need floating window support
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
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
	-- package manager
	{ "williamboman/mason.nvim", event = "VimEnter" },

	-- latex
	{ "lervag/vimtex", event = "VeryLazy" },

	-- jump
	"ggandor/leap.nvim",
}

local opts = {
	defaults = {
		lazy = false,
	},
}

lazy.setup(plugins, opts)
