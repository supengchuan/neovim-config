local M = {
  "akinsho/bufferline.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = "VeryLazy",
  cond = false,
  config = function()
    local bufferline = require("bufferline")
    bufferline.setup({
      options = {
        mode = "buffers",
        themable = false,
        middle_mouse_command = function()
          require("bufferline").sort_by(function(buf_a, buf_b)
            return buf_a.id < buf_b.id
          end)
        end,
        show_buffer_icons = true,
        numbers = "none",
        tab_size = 10,
        hover = {
          enbaled = true,
          delay = 200,
          reveal = { "close" },
        },
        indicator = {
          icon = "  ",
          style = "icon", --'icon' | 'underline' | 'none',
        },
        modified_icon = "●",
        -- 使用 nvim 内置lsp
        diagnostics = "nvim_lsp",
        --diagnostics_indicator = function(count, level, diagnostics_dict, context)
        diagnostics_indicator = function(_, _, _, context)
          -- current buffer don't show LSP indicators
          if context.buffer:current() then
            return ""
          end
          return ""
        end,
        -- 左侧让出 neo-tree 的位置
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-Tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
        color_icons = false,
        buffer_close_icon = "",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        -- slant padded_slant slope padded_slope thick thin
        separator_style = "slant",
        show_buffer_close_icon = true,
        show_close_icon = false,
        auto_toggle_bufferline = true,
        show_tab_indicators = true,
        right_mouse_command = "vertical sbuffer %d",
      },
    })
  end,
}

return M
