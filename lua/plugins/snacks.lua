local M = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    input = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    words = { enabled = true },
    debug = { enabled = true },
    notifier = { enabled = true }, -- noice may be use this
    lazygit = {
      win = {
        width = 0,
        height = 0,
      },
    },
  },
  keys = {
    {
      "<leader>t",
      function()
        Snacks.terminal()
      end,
      desc = "toggle terminal",
    },
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "lazygit toggle",
    },
  },
}

return M
