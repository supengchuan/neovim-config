local M = {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    keys = {
      { "F10", "<cmd>lua require'dap'.step_over()<CR>", desc = "debug step over" },
      { "F11", "<cmd>lua require'dap'.step_into()<CR>", desc = "debug step into" },
      { "F12", "<cmd>lua require'dap'.step_out()<CR>", desc = "debug step out" },
      { "F5", "<cmd>lua require'dap'.continue()<CR>", desc = "debug continue" },
      { "<leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", desc = "set a breakpoint" },
    },
  },
  { "leoluz/nvim-dap-go", event = "VeryLazy" },
  { "theHamsta/nvim-dap-virtual-text", event = "VeryLazy" },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  },
}

return M
