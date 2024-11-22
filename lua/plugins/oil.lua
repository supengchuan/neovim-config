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
        -- Padding around the floating window
        border = local_border,
        padding = 1,
        win_options = {
          winblend = 5,
        },
      },
      keymaps = {
        ["<2-LeftMouse>"] = "actions.select",
      },
      skip_confirm_for_simple_edits = true,
    },

    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "refractalize/oil-git-status.nvim",
    dependencies = {
      "stevearc/oil.nvim",
    },
    config = true,
    event = "VeryLazy",
  },
}

return M
