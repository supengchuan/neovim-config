local M = {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    -- stylua: ignore
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "debug continue, go to next breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "dap debug step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "dap debug step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "dap debug step out" },
      { "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "set a breakpoint" },
    },
    config = function()
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
      local dap = {
        Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
        Breakpoint = " ",
        BreakpointCondition = " ",
        BreakpointRejected = { " ", "DiagnosticError" },
        LogPoint = ".>",
      }

      for name, sign in pairs(dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "nvim-neotest/nvim-nio" },
    opts = {},
    config = function(_, opts)
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup(opts)
      local debug_open = function()
        dapui.open()
        vim.api.nvim_command("DapVirtualTextEnable")
      end
      local debug_close = function()
        dap.repl.close()
        dapui.close()
        vim.api.nvim_command("DapVirtualTextDisable")
        -- vim.api.nvim_command("bdelete! term:")   -- close debug temrinal
      end

      dap.listeners.after.event_initialized["dapui_config"] = function()
        debug_open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        debug_close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        debug_close()
      end
      dap.listeners.before.disconnect["dapui_config"] = function()
        debug_close()
      end
    end,
  },
  { "leoluz/nvim-dap-go", event = "VeryLazy", opts = {} },
}

return M
