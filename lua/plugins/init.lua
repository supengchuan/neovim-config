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
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require("nvim-highlight-colors").setup({})
    end,
  },
  --{
  --  "catgoose/nvim-colorizer.lua",
  --  event = "BufReadPre",
  --  opts = {
  --    buftypes = { "*" },
  --    user_default_options = {
  --      RRGGBBAA = true, -- #RRGGBBAA hex codes
  --      AARRGGBB = true, -- 0xAARRGGBB hex codes
  --    },
  --  },
  --},
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
    --event = "VeryLazy",
    lazy = true,
    cmd = { "DiffviewOpen", "DiffviewClose" },
  },
  {
    "noearc/jieba.nvim",
    dependencies = { "noearc/jieba-lua" },
    event = "VeryLazy",
  },
}
