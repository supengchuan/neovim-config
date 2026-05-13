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
      { "<leader>G", group = "+go" },
      { "<leader>b", group = "+build" },
      { "<leader>c", group = "+code" },
      { "<leader>d", group = "+debug" },
      { "<leader>e", group = "+explorer" },
      { "<leader>f", group = "+find" },
      { "<leader>g", group = "+git" },
      { "<leader>m", group = "+markdown" },
      { "<leader>p", group = "+python" },
      { "<leader>r", group = "+rust" },
      { "<leader>t", group = "+terminal" },
      { "<leader>u", group = "+ui" },
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>/", function() require("which-key").show({ global = true }) end, desc = "show keymap overview" },
    { "<leader>-", "<cmd>vertical resize -10<CR>", desc = "current window narrower" },
    { "<leader>=", "<cmd>vertical resize +10<CR>", desc = "current window wider" },
    { "<leader>cd", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "line diagnostics" },
    { "<leader>ch", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "hover documentation" },
    { "<leader>ci", require("utils").ToggleInlayHints, desc = "toggle inlay hints" },
    { "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "rename symbol" },
    { "<leader>uc", function() vim.fn.setreg("+", "") vim.fn.setreg("*", "") end, desc = "clear clipboard register" },
    { "<leader>uw", require("utils").ToggleWrap, desc = "toggle line wrap" },
    { ";n", "<cmd>nohlsearch<CR>", desc = "cancel highlight for search" },
    { "<leader>q", "<cmd>q<CR>", desc = "quit" },
    { "<leader>Q", "<cmd>qa!<CR>", desc = "force quit all" },
    { "<leader>w", "<cmd>w<CR>", desc = "save buffer" },
  },
}

return M
