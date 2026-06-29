local function is_lsp_progress(message, client_name, patterns)
  local progress = message.opts and message.opts.progress
  if not progress or progress.client ~= client_name then
    return false
  end

  if not patterns then
    return true
  end

  local text = string.lower(table.concat({
    progress.title or "",
    progress.message or "",
  }, " "))

  for _, pattern in ipairs(patterns) do
    if text:find(pattern, 1, true) then
      return true
    end
  end

  return false
end

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
              return is_lsp_progress(message, "pyright")
                or is_lsp_progress(message, "jdtls", {
                  "publish diagnostics",
                  "validate document",
                })
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
