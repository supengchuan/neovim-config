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
  {
    "SirZenith/oil-vcs-status",
    dependencies = {
      "stevearc/oil.nvim",
    },
    config = function()
      local status_const = require("oil-vcs-status.constant.status")

      local StatusType = status_const.StatusType

      require("oil-vcs-status").setup({
        -- Highlight group name used by each status type.
        ---@type table<oil-vcs-status.StatusType, string | false>
        status_hl_group = {
          [StatusType.Added] = "diffAdded",
          [StatusType.Copied] = "diffAdded",
          [StatusType.Deleted] = "diffRemoved",
          [StatusType.Ignored] = "Comment",
          [StatusType.Modified] = "CursorLineNr",
          [StatusType.Renamed] = "diffChanged",
          [StatusType.TypeChanged] = "diffChanged",
          [StatusType.Unmodified] = "Normal",
          [StatusType.Unmerged] = "diffRemoved",
          [StatusType.Untracked] = "diffNewFile",
          [StatusType.External] = "Normal",

          [StatusType.UpstreamAdded] = "diffAdded",
          [StatusType.UpstreamCopied] = "diffAdded",
          [StatusType.UpstreamDeleted] = "diffRemoved",
          [StatusType.UpstreamIgnored] = "Comment",
          [StatusType.UpstreamModified] = "diffChanged",
          [StatusType.UpstreamRenamed] = "diffChanged",
          [StatusType.UpstreamTypeChanged] = "diffChanged",
          [StatusType.UpstreamUnmodified] = "Normal",
          [StatusType.UpstreamUnmerged] = "diffRemoved",
          [StatusType.UpstreamUntracked] = "diffNewFile",
          [StatusType.UpstreamExternal] = "Normal",
        },

        status_symbol = {
          [StatusType.Added] = "",
          [StatusType.Copied] = "󰆏",
          [StatusType.Deleted] = "󰮘",
          [StatusType.Ignored] = "",
          [StatusType.Modified] = "󰴓",
          [StatusType.Renamed] = "",
          [StatusType.TypeChanged] = "󰉺",
          [StatusType.Unmodified] = " ",
          [StatusType.Unmerged] = "󰊢",
          [StatusType.Untracked] = "",
          [StatusType.External] = "",

          [StatusType.UpstreamAdded] = "󰈞",
          [StatusType.UpstreamCopied] = "󰈢",
          [StatusType.UpstreamDeleted] = "",
          [StatusType.UpstreamIgnored] = " ",
          [StatusType.UpstreamModified] = "󰏫",
          [StatusType.UpstreamRenamed] = "",
          [StatusType.UpstreamTypeChanged] = "󱧶",
          [StatusType.UpstreamUnmodified] = " ",
          [StatusType.UpstreamUnmerged] = "",
          [StatusType.UpstreamUntracked] = " ",
          [StatusType.UpstreamExternal] = "",
        },
      })
    end,
  },
}

return M
