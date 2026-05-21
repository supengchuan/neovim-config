return {
  "alexghergh/nvim-tmux-navigation",
  event = "VeryLazy",
  config = function()
    require("nvim-tmux-navigation").setup({
      disable_when_zoomed = false, -- defaults to false
    })
  end,
  keys = {
    { "<C-h>", "<cmd>NvimTmuxNavigateLeft<CR>", desc = "move cursor to left window" },
    { "<C-j>", "<cmd>NvimTmuxNavigateDown<CR>", desc = "move cursor to lower window" },
    { "<C-k>", "<cmd>NvimTmuxNavigateUp<CR>", desc = "move cursor to upper window" },
    { "<C-l>", "<cmd>NvimTmuxNavigateRight<CR>", desc = "move cursor to right window" },
    { "<C-\\>", "<cmd>NvimTmuxNavigateLastActive<CR>", desc = "move cursor to last active window" },
    { "<C-Space>", "<cmd>NvimTmuxNavigateNext<CR>", desc = "move cursor to next window" },
  },
}
