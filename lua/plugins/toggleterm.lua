local M = {
  "akinsho/toggleterm.nvim",
  dependencies = {
    "folke/which-key.nvim",
  },
  event = "VeryLazy",
  config = function()
    require("toggleterm").setup({
      -- size can be a number or function which is passed the current terminal
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      start_in_insert = true,
      shell = vim.o.shell,
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
      { "<esc><esc>", [[<C-\><C-n>]], desc = "esc from terminal", mode = "t" },
      -- conflict with fzf-lua
      --{ "<C-j>", [[<cmd>wincmd j<cr>]], desc = "move cursor to blow window", mode = "t" },
      --{ "<C-k>", [[<cmd>wincmd k<cr>]], desc = "move cursor to up window", mode = "t" },
      --{ "<C-l>", [[<cmd>wincmd l<cr>]], desc = "move cursor to rigth window", mode = "t" },
      --{ "<C-h>", [[<cmd>wincmd h<cr>]], desc = "move cursor to left window", mode = "t" },
    })
  end,
}

return M
