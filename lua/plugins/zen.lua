return {
  "folke/zen-mode.nvim",
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    window = {
      width = 0.85,
    },
    plugins = {
      tmux = { enabled = true },
      todo = { enabled = true },
      gitsigns = { enabled = true },
    },
  },
  keys = {
    { "<leader>z", "<cmd>lua require('zen-mode').toggle({window = {width = 0.85}})<cr>", desc = "toggle zen mode" },
  },
}
