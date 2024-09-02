local function customTheme()
  local colors = {
    darkgray = "#16161d",
    gray = "#727169",
    innerbg = nil,
    outerbg = "#16161D",
    normal = "#7e9cd8",
    insert = "#98bb6c",
    visual = "#ffa066",
    replace = "#e46876",
    command = "#e6c384",
  }
  return {
    inactive = {
      a = { fg = colors.gray, bg = colors.outerbg, gui = "bold" },
      b = { fg = colors.gray, bg = colors.outerbg },
      c = { fg = colors.gray, bg = colors.innerbg },
    },
    visual = {
      a = { fg = colors.darkgray, bg = colors.visual, gui = "bold" },
      b = { fg = colors.gray, bg = colors.outerbg },
      c = { fg = colors.gray, bg = colors.innerbg },
    },
    replace = {
      a = { fg = colors.darkgray, bg = colors.replace, gui = "bold" },
      b = { fg = colors.gray, bg = colors.outerbg },
      c = { fg = colors.gray, bg = colors.innerbg },
    },
    normal = {
      a = { fg = colors.darkgray, bg = colors.normal, gui = "bold" },
      b = { fg = colors.gray, bg = colors.outerbg },
      c = { fg = colors.gray, bg = colors.innerbg },
    },
    insert = {
      a = { fg = colors.darkgray, bg = colors.insert, gui = "bold" },
      b = { fg = colors.gray, bg = colors.outerbg },
      c = { fg = colors.gray, bg = colors.innerbg },
    },
    command = {
      a = { fg = colors.darkgray, bg = colors.command, gui = "bold" },
      b = { fg = colors.gray, bg = colors.outerbg },
      c = { fg = colors.gray, bg = colors.innerbg },
    },
  }
end

local M = {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    options = {
      icons_enabled = true,
      --theme = "dracula-nvim",
      --theme = "everforest",
      theme = customTheme(),
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_c = {
        {
          "filename",
          file_status = true, -- Displays file status (readonly status, modified status)
          path = 1, -- 0: Just the filename
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
      lualine_x = { "lsp_progress", "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },

    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = { "man", "nvim-tree", "aerial", "nvim-dap-ui" },
  },
}

return M
