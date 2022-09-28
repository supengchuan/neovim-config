-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function()
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
	use("hrsh7th/cmp-vsnip") -- { name = 'vsnip' }
	use("hrsh7th/vim-vsnip")
	use("rafamadriz/friendly-snippets")
	-- lspkind
	use("onsails/lspkind-nvim")

	-- bufferline
	use({ "akinsho/bufferline.nvim", requires = "kyazdani42/nvim-web-devicons" })
	use("jiangmiao/auto-pairs")
	use("alvan/vim-closetag")
	use("tpope/vim-unimpaired")
	use("tpope/vim-surround")

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

	use("voldikss/vim-floaterm")

	use("nvim-lua/plenary.nvim")
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use("mhinz/vim-startify")

	-- git graph
	use("rbong/vim-flog")
	-- color
	use("norcalli/nvim-colorizer.lua")

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
end)
