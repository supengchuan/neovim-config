local M = {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  config = function()
    require("tiny-inline-diagnostic").setup({
      -- Style preset for diagnostic messages
      -- Available options: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
      preset = "ghost",

      options = {
        show_source = {
          enabled = true,
          if_many = true,
        },
        -- Configuration for breaking long messages into separate lines
        break_line = {
          -- Enable breaking messages after a specific length
          enabled = true,

          -- Number of characters after which to break the line
          after = 50,
        },
      },
    })
    vim.diagnostic.config({
      virtual_text = false,
    })
  end,
}

return M
