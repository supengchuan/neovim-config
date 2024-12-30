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
    --common keymaps
    { "jj", "<ESC>", desc = "double j to normal mode", mode = "i" },
    { "<leader>+", "<cmd>vertical resize -10<CR>", desc = "current buffer narrower" },
    { "<leader><CR>", require("utils").Toggle_wrap, desc = "set file wrap or no wrap" },
    { "<leader>=", "<cmd>vertical resize +10<CR>", desc = "current buffer wider" },
    { "<leader>d[", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "go to previous diagnostic" },
    { "<leader>d]", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "go to next diagnostic" },
    { "<leader>h", require("utils").Toggle_inlay_hints, desc = "set a buffer enable inlay hints or not" },
    { "<leader>i", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "open diagnostic as float window" },
    { "<leader>j", "5j", desc = "move cursor down five lines" },
    { "<leader>k", "5k", desc = "move cursor up five lines" },
    { "<leader>nl", "<cmd>nohlsearch<CR>", desc = "cancel highlight for search" },
    { "<leader>q", "<cmd>q<CR>", desc = "quit from current buffer" },
    { "<leader>Q", "<cmd>qa!<CR>", desc = "force quit all" },
    { "<leader>w", "<cmd>w<CR>", desc = "save current buffer" },
  },
}

return M
