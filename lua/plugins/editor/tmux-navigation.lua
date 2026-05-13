return {
  "alexghergh/nvim-tmux-navigation",
  event = "VeryLazy",
  config = function()
    require("nvim-tmux-navigation").setup({
      disable_when_zoomed = false, -- defaults to false
      keybindings = {
        last_active = "<C-\\>",
        next = "<C-Space>",
      },
    })
  end,
  keys = {
    { "<C-h>", "<cmd>NvimTmuxNavigateLeft<CR>", desc = "move cursor to left window" },
    { "<C-j>", "<cmd>NvimTmuxNavigateDown<CR>", desc = "move cursor to blow window" },
    { "<C-k>", "<cmd>NvimTmuxNavigateUp<CR>", desc = "move cursor to up window" },
    { "<C-l>", "<cmd>NvimTmuxNavigateRight<CR>", desc = "move cursor to right window" },
  },
}
