local M = {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    require("tokyonight").setup({
      style = "moon",
      transparent = false, -- Enable this to disable setting the background colors
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "dark",
        floats = "transparent", -- style for floating windows
      },
      hide_inactive_statusline = true, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
      dim_inactive = true, -- dims inactive windows
      lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold
      plugins = {
        all = package.loaded.lazy == nil,
        auto = true,
        --bufferline = true,
        leap = false,
      },
    })
  end,
}

return M
