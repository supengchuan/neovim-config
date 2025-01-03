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
    opts = {},
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
    keys = {
      {
        "<leader>m",
        "<cmd>WinShift<cr>",
        desc = "move window",
      },
    },
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
