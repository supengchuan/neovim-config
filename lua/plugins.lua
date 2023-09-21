-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd([[packadd packer.nvim]])

local packer = require("packer")
packer.init({
	max_jobs = 20,
})
return packer.startup({
	function(use)
		-- Packer can manage itself
		use("wbthomason/packer.nvim")
		use("nvim-tree/nvim-web-devicons")
		use("nvim-tree/nvim-tree.lua")
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			requires = {
				"nvim-tree/nvim-web-devicons",
			},
		})
		use("neovim/nvim-lspconfig") -- Collection of configurations for the built-in LSP client
		-- theme
		use("Mofiqul/dracula.nvim")
		use("neanias/everforest-nvim")
		use("marko-cerovac/material.nvim")
		use { "ellisonleao/gruvbox.nvim" }
		-- nvim-cmp
		use("hrsh7th/cmp-nvim-lsp")
		use("hrsh7th/cmp-nvim-lua")
		use("hrsh7th/cmp-buffer")
		use("hrsh7th/cmp-path")
		use("hrsh7th/cmp-cmdline")
		use("hrsh7th/nvim-cmp")
		-- vsnip
		use("rafamadriz/friendly-snippets")
		-- lspkind
		use("onsails/lspkind-nvim")

		use({ "L3MON4D3/LuaSnip" })
		use({ "saadparwaiz1/cmp_luasnip" })

		-- bufferline
		use({ "akinsho/bufferline.nvim", requires = "nvim-tree/nvim-web-devicons" })
		use("famiu/bufdelete.nvim")

		use({
			"windwp/nvim-autopairs",
			config = function()
				require("nvim-autopairs").setup({})
			end,
		})
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

		use("arkav/lualine-lsp-progress")
		use({
			"nvim-lualine/lualine.nvim",
			requires = { "nvim-tree/nvim-web-devicons", opt = true },
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

		-- float termnial
		use({
			"akinsho/toggleterm.nvim",
			tag = "*",
			config = function()
				require("toggleterm").setup()
			end,
		})
		-- telescope
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

		use({
			"glepnir/dashboard-nvim",

			event = "VimEnter",
			config = function()
				require("dashboard").setup({
					-- config
				})
			end,
			requires = { "nvim-tree/nvim-web-devicons" },
		})

		-- git graph
		use("rbong/vim-flog")
		-- color
		use("norcalli/nvim-colorizer.lua")

		--debug
		use("mfussenegger/nvim-dap")
		use("leoluz/nvim-dap-go")
		use("theHamsta/nvim-dap-virtual-text")
		use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })

		-- golang tool
		use("ray-x/go.nvim")
		use("ray-x/guihua.lua") -- recommended if need floating window support
		use({
			"folke/trouble.nvim",
			requires = "nvim-tree/nvim-web-devicons",
			config = function()
				require("trouble").setup({
					-- your configuration comes here
					-- or leave it empty to use the default settings

					-- refer to the configuration section below
				})
			end,
		})
		-- markdown
		-- install without yarn or npm
		use({
			"iamcco/markdown-preview.nvim",
			run = function()
				vim.fn["mkdp#util#install"]()
			end,
		})
		-- key map
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
		-- indent
		use("lukas-reineke/indent-blankline.nvim")
		-- package manager
		use({ "williamboman/mason.nvim" })

		-- latex
		use({ "lervag/vimtex" })

		-- jump
		use("ggandor/leap.nvim")
	end,
})
