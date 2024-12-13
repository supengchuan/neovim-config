local M = {
  "SmiteshP/nvim-navbuddy",
  dependencies = {
    "SmiteshP/nvim-navic",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    lsp = { auto_attach = true },
    window = {
      size = {
        height = "80%",
        width = "80%",
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
