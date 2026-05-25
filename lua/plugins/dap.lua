local M = {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
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
      local dapSigns = {
        Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
        Breakpoint = " ",
        BreakpointCondition = " ",
        BreakpointRejected = { " ", "DiagnosticError" },
        LogPoint = ".>",
      }

      for name, sign in pairs(dapSigns) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end
      require("dap").adapters.codelldb = {
        type = "executable",
        command = "codelldb",
      }
    end,
  },
  { "leoluz/nvim-dap-go", ft = { "go", "gomod" }, opts = {} },
  {
    "igorlfs/nvim-dap-view",
    -- let the plugin lazy load itself
    lazy = false,
    version = "1.*",
    ---@module 'dap-view'
    ---@type dapview.Config
    opts = {
      winbar = {
        default_section = "scopes",
        show_keymap_hints = false,
        controls = {
          enabled = true,
        },
      },
      windows = {
        position = "below",
        size = 0.25,
      },
      virtual_text = {
        enabled = true,
      },
      -- Keep debuggee output visible after the session ends.
      auto_toggle = "keep_terminal",
      follow_tab = true,
    },
    keys = {
      { "<leader>du", "<cmd>DapViewToggle<cr>", desc = "toggle dap view" },
      { "<leader>dw", "<cmd>DapViewWatch<cr>", mode = { "n", "v" }, desc = "add dap watch" },
    },
    config = function(_, opts)
      local dap = require("dap")

      require("dap-view").setup(opts)

      dap.listeners.after.event_initialized["prevent-insert-mode"] = function()
        vim.defer_fn(function()
          local ft = vim.bo.filetype
          local mode = vim.fn.mode()
          -- Only force <Esc> in normal code files, not terminals or DAP REPLs
          if mode == "i" and ft ~= "dap-repl" and ft ~= "terminal" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
          end
        end, 100)
      end
    end,
  },
}

return M
