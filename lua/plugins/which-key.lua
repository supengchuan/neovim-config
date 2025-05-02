local M = {
  "folke/which-key.nvim",
  dependencies = {
    { "echasnovski/mini.icons", event = "VeryLazy" },
  },
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    preset = "modern",
    expand = 1, -- expand groups when <= n mappings
    icons = {
      rules = {
        { plugin = "nvim-dap", cat = "filetype", name = "dap", icon = "󰃤" },
        { pattern = "move", icon = "󱕒" },
        { pattern = "preview", icon = "" },
        { pattern = "clear", icon = "󰉥" },
        { pattern = "add", icon = "" },
      },
    },
    spec = {
      { "<leader>g", group = "+git" },
      { "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "show lsp hint" },
      { "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "rename code" },
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>/", function() require("which-key").show({ global = true }) end, desc = "Buffer Local Keymaps (which-key)" },
    --common keymaps
    { "<leader>+", "<cmd>vertical resize -10<CR>", desc = "current buffer narrower" },
    { "<leader>=", "<cmd>vertical resize +10<CR>", desc = "current buffer wider" },
    { "<leader><CR>", require("utils").ToggleWrap, desc = "set file wrap or no wrap" },
    { "<leader>h", require("utils").ToggleInlayHints, desc = "toggle inlay hints or not" },
    { "<leader>i", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "open diagnostic as float window" },
    { "<leader>j", "5j", desc = "move cursor down five lines" },
    { "<leader>k", "5k", desc = "move cursor up five lines" },
    { ";n", "<cmd>nohlsearch<CR>", desc = "cancel highlight for search" },
    { "<leader>q", "<cmd>q<CR>", desc = "quit" },
    { "<leader>Q", "<cmd>qa!<CR>", desc = "force quit all" },
    { "<leader>w", "<cmd>w<CR>", desc = "save buffer" },
    { "<leader>x", function() vim.fn.setreg("+", "") vim.fn.setreg("*", "") end, desc = "clear clipboard register" },
  },
}

return M
