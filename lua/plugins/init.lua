return {
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

  --debug
  { "mfussenegger/nvim-dap", event = "VeryLazy" },
  { "leoluz/nvim-dap-go", event = "VeryLazy" },
  { "theHamsta/nvim-dap-virtual-text", event = "VeryLazy" },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  },

  {
    "folke/trouble.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },

  -- key map
  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "sindrets/winshift.nvim",
    event = "VeryLazy",
  },
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
  },
  {
    "noearc/jieba.nvim",
    dependencies = { "noearc/jieba-lua" },
    event = "VeryLazy",
  },
}
