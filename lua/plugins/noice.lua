return {
  "folke/noice.nvim",
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
  },
  event = "VeryLazy",
  config = function()
    require("noice").setup({
      routes = {
        {
          filter = {
            event = "lsp",
            kind = "progress",
            cond = function(message)
              local progress = message.opts and message.opts.progress
              return progress and progress.client == "pyright"
            end,
          },
          opts = { skip = true },
        },
      },
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
        progress = {
          -- Pyright sends frequent indexing/analyzing progress messages; keep them out of popups.
          enabled = true,
        },
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
