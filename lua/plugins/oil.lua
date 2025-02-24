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
        padding = 2,
        win_options = {
          winblend = 0,
        },
      },
      keymaps = {
        ["<2-LeftMouse>"] = "actions.select",
      },
      skip_confirm_for_simple_edits = true,
    },
    keys = {
      { "<leader>a", "<cmd>lua require('oil').toggle_float()<cr>", desc = "open oil float window" },
    },
  },
}

return M
