local M = {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  config = function()
    require("tiny-inline-diagnostic").setup({
      -- Style preset for diagnostic messages
      -- Available options: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
      preset = "powerline",

      options = {
        add_messages = {
          display_count = true,
        },
        multilines = {
          enabled = true,
        },
        show_source = {
          enabled = true,
          if_many = true,
        },
        -- Color the arrow to match the severity of the first diagnostic
        set_arrow_to_diag_color = true,

        -- Configuration for breaking long messages into separate lines
        break_line = {
          -- Enable breaking messages after a specific length
          enabled = true,
          -- Number of characters after which to break the line
          after = 80,
        },
      },
    })
    vim.diagnostic.config({
      virtual_text = false,
    })
  end,
}

return M
