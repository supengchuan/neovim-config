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
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "debug continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "debug step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "debug step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "debug step out" },
    },
    config = function()
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
      local function codelldb_command()
        local command = vim.fn.exepath("codelldb")
        if command ~= "" then
          return command
        end

        return "codelldb"
      end

      local function default_debug_program()
        local candidates = {
          vim.fn.getcwd() .. "/build/Debug/",
          vim.fn.getcwd() .. "/build/",
          vim.fn.getcwd() .. "/out/Debug/",
        }

        for _, path in ipairs(candidates) do
          if vim.fn.isdirectory(path) == 1 then
            return path
          end
        end

        return vim.fn.getcwd() .. "/"
      end

      local function debug_args()
        local args = vim.fn.input("Program arguments: ")
        if args == "" then
          return {}
        end

        return vim.split(args, " ", { trimempty = true })
      end

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
        command = codelldb_command(),
      }

      local cpp_launch = {
        name = "Launch executable",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", default_debug_program(), "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = debug_args,
      }

      require("dap").configurations.c = { cpp_launch }
      require("dap").configurations.cpp = { cpp_launch }
      require("dap").configurations.rust = { cpp_launch }
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
  {
    "leoluz/nvim-dap-go",
    ft = { "go", "gomod", "gowork" },
    dependencies = { "mfussenegger/nvim-dap" },
    opts = function()
      local dlv = vim.fn.exepath("dlv")
      if dlv == "" then
        dlv = "dlv"
      end

      return {
        delve = {
          path = dlv,
          initialize_timeout_sec = 20,
          port = "${port}",
          args = {},
        },
      }
    end,
  },
}

return M
