local M = {
  "folke/which-key.nvim",
  dependencies = {
    "echasnovski/mini.icons",
  },
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    preset = "modern",
  },
  keys = {
    {
      "<leader>/",
      function()
        require("which-key").show({ global = true })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
    { "jj", "<ESC>", desc = "double j to normal mode", mode = "i" },
  },
}

return M
