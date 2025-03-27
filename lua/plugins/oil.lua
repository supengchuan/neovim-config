local local_border = {
  { "🭽", "FloatBorder" },
  { "▔", "FloatBorder" },
  { "🭾", "FloatBorder" },
  { "▕", "FloatBorder" },
  { "🭿", "FloatBorder" },
  { "▁", "FloatBorder" },
  { "🭼", "FloatBorder" },
  { "▏", "FloatBorder" },
}
local M = {
  {
    "stevearc/oil.nvim",
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
      columns = {
        "icon",
      },
      win_options = {
        signcolumn = "yes:2",
      },
      view_options = {
        show_hidden = true,
      },
      -- Configuration for the floating window in oil.open_float
      float = {
        max_width = 0,
        max_height = 0,
        -- Padding around the floating window
        --border = local_border,
        border = "single",

        padding = 2,
        win_options = {
          winblend = 0,
        },
        preview_split = "below",
      },
      keymaps = {
        ["<2-LeftMouse>"] = "actions.select",
        ["J"] = "actions.preview_scroll_down",
        ["K"] = "actions.preview_scroll_up",
        ["q"] = "actions.close",
      },
      skip_confirm_for_simple_edits = true,
    },
    keys = {
      {
        -- toggle oil with preview mode
        "<leader>a",
        function()
          local l_oil = require("oil")
          if vim.w.is_oil_win then
            l_oil.close()
          else
            l_oil.open_float(nil, { preview = {} })
          end
        end,
        desc = "open oil with preview",
      },
    },
  },
}

return M
