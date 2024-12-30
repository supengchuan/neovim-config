local M = {
  "SmiteshP/nvim-navbuddy",
  dependencies = {
    "SmiteshP/nvim-navic",
    "MunifTanjim/nui.nvim",
  },
  lazy = true,
  event = "VeryLazy",
  opts = {
    lsp = { auto_attach = true },
    window = {
      position = {
        row = "100%",
        col = "100%",
      },
      size = {
        height = "100%",
        width = "90%",
      },
    },
  },
  keys = {
    {
      "<leader>u",
      function()
        require("nvim-navbuddy").open()
      end,
      desc = "outline current buffers like ranger",
    },
  },
}

return M
