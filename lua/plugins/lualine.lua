local M = {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "folke/noice.nvim",
  },
  event = "VeryLazy",
  opts = {
    options = {
      icons_enabled = true,
      --theme = "dracula-nvim",
      --theme = "everforest",
      --theme = customTheme(),
      theme = vim.g.colors_name,
      section_separators = { left = "", right = "" },
      --section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 100,
        tabline = 100,
        winbar = 100,
      },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_c = {
        {
          "filename",
          file_status = true, -- Displays file status (readonly status, modified status)
          path = 3, -- 0: Just the filename
          -- 1: Relative path
          -- 2: Absolute path
          -- 3: Absolute path, with tilde as the home directory
          shorting_target = 30, -- Shortens path to leave 40 spaces in the window
          symbols = {
            modified = "[+]", -- Text to show when the file is modified.
            readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
            unnamed = "[No Name]", -- Text to show for unnamed buffers.
          },
        },
      },
      lualine_b = { "branch", "diff" },
      lualine_x = {
        "lsp_progress",
        "encoding",
        "fileformat",
        "filetype",
        {
          require("noice").api.status.mode.get,
          cond = require("noice").api.status.mode.has,
          color = { fg = "#ff9e64" },
        },
      },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },

    inactive_sections = {
      lualine_a = {},
      lualine_b = { "branch", "diff" },
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {
      lualine_a = { "mode" },
      lualine_b = { "searchcount", "selectioncount" },
      lualine_c = {
        {
          "windows",
          -- Automatically updates active window color to match color of other components (will be overidden if buffers_color is set)
          use_mode_colors = true,
          show_modified_status = true, -- Shows indicator when the window is modified.

          mode = 0, -- 0: Shows window name
          -- 1: Shows window index
          -- 2: Shows window name + window index

          filetype_names = {
            Avante = "Avante",
            AvanteSelectedFiles = "AvanteSelectedFiles",
            AvanteInput = "AvanteInput",
          }, -- Shows specific window name for that filetype ( { `filetype` = `window_name`, ... } )

          disabled_buftypes = { "quickfix", "prompt", "nofile" }, -- Hide a window if its buffer's type is disabled
        },
      },
      lualine_x = { "lsp_status" },
      lualine_y = { "tabs" },
      lualine_z = { "mode" },
    },
    winbar = {},
    inactive_winbar = {},
    extensions = { "man", "neo-tree", "aerial", "nvim-dap-ui", "avante" },
  },
}

return M
