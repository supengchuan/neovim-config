local M = {
  "akinsho/toggleterm.nvim",
  dependencies = {
    "folke/which-key.nvim",
  },
  event = "VeryLazy",
  config = function()
    local st_floattus, toggleterm = pcall(require, "toggleterm")
    if not st_floattus then
      vim.notify("没有找到 toggleterm")
      return
    end

    local on_windows = vim.uv.os_uname().sysname:match("Windows")
    if on_windows then
      -- use pwsh on windows
      vim.opt.shell = vim.fn.executable("pwsh") and "pwsh" or "powershell"
      vim.opt.shellcmdflag =
        "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
      vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
      vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
      vim.opt.shellquote = ""
      vim.opt.shellxquote = ""
    end

    toggleterm.setup({
      -- size can be a number or function which is passed the current terminal
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      start_in_insert = true,
      shell = function()
        if on_windows then
          return "pwsh"
        else
          return vim.o.shell
        end
      end,
    })

    local Terminal = require("toggleterm.terminal").Terminal

    local lazygit = Terminal:new({
      direction = "tab",
      cmd = "lazygit",
      hidden = true,
    })

    -- register hot key
    local wk = require("which-key")

    --stylua: ignore
    wk.add({
      { "<C-t>", [[<cmd>ToggleTerm<cr>]], desc = "toggleterm", mode = "t" },
      { "<leader>gg", function() lazygit:toggle() end, desc = "lazygit toggle using terminal" },
      { "<leader>t", [[<cmd>ToggleTerm direction=horizontal<cr>]], desc = "toggleterm" },
--      { "<esc>", [[<C-\><C-n>]], desc = "esc from terminal", mode = "t" },
      { "<C-j>", [[<cmd>wincmd j<cr>]], desc = "move cursor to blow window", mode = "t" },
      { "<C-k>", [[<cmd>wincmd k<cr>]], desc = "move cursor to up window", mode = "t" },
      { "<C-l>", [[<cmd>wincmd l<cr>]], desc = "move cursor to rigth window", mode = "t" },
      { "<C-h>", [[<cmd>wincmd h<cr>]], desc = "move cursor to left window", mode = "t" },
    })
  end,
}

return M
