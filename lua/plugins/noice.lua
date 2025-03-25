return {
  "folke/noice.nvim",
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
  },
  event = "VeryLazy",
  config = function()
    require("noice").setup({
      presets = {
        lsp_doc_border = true,
      },
      views = {
        mini = {
          win_options = {
            winhighlight = {
              Normal = "Normal",
            },
            winblend = 100,
          },
        },
        hover = {
          size = {
            max_width = math.floor(vim.o.columns * 0.8) > 120 and 120 or math.floor(vim.o.columns * 0.8),
          },
        },
      },
      cmdline = {
        view = "cmdline_popup",
        format = {
          cmdline = { pattern = "^:", icon = " 󰁕", lang = "vim" },
          search_down = {
            view = "cmdline_popup",
          },
          search_up = {
            view = "cmdline_popup",
          },
        },
      },
      lsp = {
        hover = {
          view = "hover",
        },
        signature = {
          enabled = true,
        },
      },
      messages = {
        view = "mini",
        view_error = "notify",
        view_warn = "notify",
      },
    })
  end,
}
