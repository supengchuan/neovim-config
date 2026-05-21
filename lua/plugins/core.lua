return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {}, -- this is equalent to setup({}) function
  },
  { "windwp/nvim-ts-autotag", opts = {} },
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
      local color_filetypes = {
        css = true,
        html = true,
        javascript = true,
        javascriptreact = true,
        json = true,
        less = true,
        lua = true,
        sass = true,
        scss = true,
        toml = true,
        typescript = true,
        typescriptreact = true,
        vue = true,
        yaml = true,
      }

      require("nvim-highlight-colors").setup({
        exclude_buffer = function(bufnr)
          return not color_filetypes[vim.bo[bufnr].filetype]
        end,
      })
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
        "<leader>M",
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
}
