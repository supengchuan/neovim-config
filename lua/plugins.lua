-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'preservim/nerdtree'
  use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
  use 'neovim/nvim-lspconfig' -- Collection of configurations for the built-in LSP client
  -- theme
  use 'sainnhe/sonokai'
  use { "ellisonleao/gruvbox.nvim" }
  use 'fatih/molokai'
  use  'fatih/vim-go'
  use 'darrikonn/vim-gofmt'
  -- nvim-cmp
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  -- vsnip
  use 'hrsh7th/cmp-vsnip'    -- { name = 'vsnip' }
  use 'hrsh7th/vim-vsnip'
  use 'rafamadriz/friendly-snippets'
  -- lspkind
  use 'onsails/lspkind-nvim'

  -- bufferline
  use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
  use "jiangmiao/auto-pairs"
  use "alvan/vim-closetag"
  use "tpope/vim-unimpaired"
  use "tpope/vim-surround"

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }	
  use 'tpope/vim-fugitive'
  use 'lewis6991/gitsigns.nvim'
  -- rust  To enable more of the features of rust-analyzer, such as inlay hints and more!
  use 'simrat39/rust-tools.nvim'
end)

