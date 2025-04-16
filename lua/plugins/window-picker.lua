local M = {
  "s1n7ax/nvim-window-picker",
  name = "window-picker",
  event = "VeryLazy",
  version = "2.*",
  config = function()
    require("window-picker").setup({
      -- type of hints you want to get
      -- following types are supported
      -- 'statusline-winbar' | 'floating-big-letter' | 'floating-letter'
      -- 'statusline-winbar' draw on 'statusline' if possible, if not 'winbar' will be
      -- 'floating-big-letter' draw big letter on a floating window
      -- 'floating-letter' draw letter on a floating window
      -- used
      hint = "floating-big-letter",
      filter_rules = {
        bo = {
          filetype = { "oil", "notify", "snacks_notif" },
          buftype = {},
        },
      },
    })
  end,
  keys = {
    {
      "<leader>p",
      function()
        if vim.w.is_oil_win then
          return
        end
        local window_id = require("window-picker").pick_window({
          include_current_win = false,
        })
        if window_id then
          vim.api.nvim_set_current_win(window_id)
        end
      end,
      desc = "chose window",
    },
  },
}

return M
