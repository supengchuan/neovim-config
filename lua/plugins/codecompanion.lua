local M = {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "codecompanion" },
    },
    "folke/noice.nvim",
  },

  init = function()
    require("modules.ai.extensions.companion-notification").init()
  end,

  cmd = {
    "CodeCompanion",
    "CodeCompanionActions",
    "CodeCompanionChat",
    "CodeCompanionCmd",
  },
  opts = {
    strategies = {
      chat = {
        adapter = "gemini",
      },
      inline = {
        adapter = "gemini",
      },
    },
    adapter = {
      gemini = function()
        require("codecompanion.adapters").extend("gemini", {
          env = {
            api_key = "GEMINI_API_KEY",
          },
        })
      end,
    },
    display = {
      chat = {
        window = {
          position = "right", -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)
          width = 0.3,
        },
      },
    },
  },
}

return M
