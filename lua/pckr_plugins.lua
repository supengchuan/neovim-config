require("pckr").add({
	-- Packer can manage itself
	"wbthomason/packer.nvim",
	"nvim-tree/nvim-web-devicons",
	"nvim-tree/nvim-tree.lua",
	{
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		requires = {
			"nvim-tree/nvim-web-devicons",
		},
	},
	"neovim/nvim-lspconfig", -- Collection of configurations for the built-in LSP client
	-- theme
	-- nvim-cmp
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lua",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/nvim-cmp",
	-- vsnip
	"rafamadriz/friendly-snippets",
	-- lspkind
	"onsails/lspkind-nvim",

	{ "L3MON4D3/LuaSnip" },
	{ "saadparwaiz1/cmp_luasnip" },

	-- bufferline
	{ "akinsho/bufferline.nvim", requires = "nvim-tree/nvim-web-devicons" },
	"famiu/bufdelete.nvim",

	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	"tpope/vim-unimpaired",
	{
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup({})
		end,
	},

	"arkav/lualine-lsp-progress",
	{
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	},
	"tpope/vim-fugitive",
	"lewis6991/gitsigns.nvim",
	-- rust  To enable more of the features of rust-analyzer, such as inlay hints and more!
	"simrat39/rust-tools.nvim",
	"rust-lang/rust.vim",

	-- format
	"mhartington/formatter.nvim",
	-- outline
	{
		"stevearc/aerial.nvim",
		--config = function() require('aerial').setup() end
	},
	-- float termnial
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup()
		end,
	},
	-- telescope
	"nvim-lua/plenary.nvim",
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		requires = { { "nvim-lua/plenary.nvim" } },
	},
	-- improve telescope performance
	{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
	-- look environment variables with telescope
	{ "LinArcX/telescope-env.nvim" },
	-- Project need
	{ "nvim-telescope/telescope-project.nvim" },
	-- telesocpe-dap
	"nvim-telescope/telescope-dap.nvim",

	{
		"glepnir/dashboard-nvim",

		event = "VimEnter",
		config = function()
			require("dashboard").setup({
				-- config
			})
		end,
		requires = { "nvim-tree/nvim-web-devicons" },
	},

	-- git graph
	"rbong/vim-flog",
	-- color
	"norcalli/nvim-colorizer.lua",

	--debug
	"mfussenegger/nvim-dap",
	"leoluz/nvim-dap-go",
	"theHamsta/nvim-dap-virtual-text",
	{ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } },

	-- golang tool
	"ray-x/go.nvim",
	"ray-x/guihua.lua", -- recommended if need floating window support
	{
		"folke/trouble.nvim",
		requires = "nvim-tree/nvim-web-devicons",
		config = function()
			require("trouble").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings

				-- refer to the configuration section below
			})
		end,
	},
	-- markdown
	-- install without yarn or npm
	{
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	-- key map
	{
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	},
	-- indent
	"lukas-reineke/indent-blankline.nvim",
	-- package manager
	{ "williamboman/mason.nvim" },

	-- latex
	{ "lervag/vimtex" },

	-- jump
	"ggandor/leap.nvim",

	"Mofiqul/dracula.nvim",
	"neanias/everforest-nvim",
	"marko-cerovac/material.nvim",
	{ "ellisonleao/gruvbox.nvim" },
	"folke/tokyonight.nvim",
})
