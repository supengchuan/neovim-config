-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

local packer = require("packer")
packer.init({
	max_jobs = 20,
})
return packer.startup({
	function(use)
		-- Packer can manage itself
		use("wbthomason/packer.nvim")
		use("kyazdani42/nvim-web-devicons")
		use("kyazdani42/nvim-tree.lua")
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			requires = {
				"kyazdani42/nvim-web-devicons",
			},
		})
		use("neovim/nvim-lspconfig") -- Collection of configurations for the built-in LSP client
		-- theme
		use("tanvirtin/monokai.nvim")
		use("morhetz/gruvbox")

		--use 'fatih/vim-go'
		use("darrikonn/vim-gofmt")
		-- nvim-cmp
		use("hrsh7th/cmp-nvim-lsp")
		use("hrsh7th/cmp-buffer")
		use("hrsh7th/cmp-path")
		use("hrsh7th/cmp-cmdline")
		use("hrsh7th/nvim-cmp")
		-- vsnip
		use("rafamadriz/friendly-snippets")
		-- lspkind
		use("onsails/lspkind-nvim")

		use("L3MON4D3/LuaSnip")
		use("saadparwaiz1/cmp_luasnip")
		-- bufferline
		use({ "akinsho/bufferline.nvim", requires = "kyazdani42/nvim-web-devicons" })
		use("famiu/bufdelete.nvim")

		use("jiangmiao/auto-pairs")
		use("alvan/vim-closetag")
		use("tpope/vim-unimpaired")
		use({
			"kylechui/nvim-surround",
			tag = "*", -- Use for stability; omit to use `main` branch for the latest features
			config = function()
				require("nvim-surround").setup({
					-- Configuration here, or leave empty to use defaults
				})
			end,
		})

		use({
			"nvim-lualine/lualine.nvim",
			requires = { "kyazdani42/nvim-web-devicons", opt = true },
		})
		use("tpope/vim-fugitive")
		use("lewis6991/gitsigns.nvim")
		-- rust  To enable more of the features of rust-analyzer, such as inlay hints and more!
		use("simrat39/rust-tools.nvim")
		use("rust-lang/rust.vim")

		-- format
		use("mhartington/formatter.nvim")
		-- outline
		use({
			"stevearc/aerial.nvim",
			--config = function() require('aerial').setup() end
		})

		use({
			"akinsho/toggleterm.nvim",
			tag = "*",
			config = function()
				require("toggleterm").setup()
			end,
		})
		use("nvim-lua/plenary.nvim")
		use({
			"nvim-telescope/telescope.nvim",
			tag = "0.1.0",
			requires = { { "nvim-lua/plenary.nvim" } },
		})
		-- improve telescope performance
		use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
		-- look environment variables with telescope
		use({ "LinArcX/telescope-env.nvim" })
		-- Project need
		use({ "nvim-telescope/telescope-project.nvim" })
		-- telesocpe-dap
		use("nvim-telescope/telescope-dap.nvim")

		use("mhinz/vim-startify")

		-- git graph
		use("rbong/vim-flog")
		-- color
		use("norcalli/nvim-colorizer.lua")
		use("Mofiqul/dracula.nvim")

		--debug
		use("mfussenegger/nvim-dap")
		use("leoluz/nvim-dap-go")
		use("theHamsta/nvim-dap-virtual-text")
		use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })

		-- markdown
		-- install without yarn or npm
		use({
			"iamcco/markdown-preview.nvim",
			run = function()
				vim.fn["mkdp#util#install"]()
			end,
		})
		-- Lua
		use({
			"folke/which-key.nvim",
			config = function()
				require("which-key").setup({
					-- your configuration comes here
					-- or leave it empty to use the default settings
					-- refer to the configuration section below
				})
			end,
		})
		--
		use("lukas-reineke/indent-blankline.nvim")
		-- TODO Comments
		use({
			"folke/todo-comments.nvim",
			requires = "nvim-lua/plenary.nvim",
		})
		--
		use({ "williamboman/mason.nvim" })
	end,
})
