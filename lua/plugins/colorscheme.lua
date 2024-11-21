return {
  {
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
        hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
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
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
        transparent_background = false, -- disables setting the background color.
        no_underline = true, -- Force no underline
        term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = false, -- dims the background color of inactive window
          shade = "dark",
          percentage = 0.9, -- percentage of the shade to apply to the inactive window
        },

        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { "italic" }, -- Change the style of comments
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = { "bold" },
          strings = { "italic" },
          variables = {},
          numbers = { "bold" },
          booleans = {},
          properties = {},
          types = {},
          operators = { "bold" },
        },

        integrations = {
          bufferline = true,
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
          leap = false, -- only set bg transparent can make this enabled
          aerial = true,
        },
        -- disable overide color for comments
        custom_highlights = function(colors)
          return {
            LeapBackdrop = { fg = colors.overlay0 },
          }
        end,
      })
    end,
  },
  {
    "maxmx03/dracula.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      ---@type dracula
      local dracula = require("dracula")

      dracula.setup({
        styles = {
          Type = {},
          Function = {},
          Parameter = {},
          Property = {},
          Comment = {},
          String = {},
          Keyword = {},
          Identifier = {},
          Constant = {},
        },
        transparent = false,
        on_highlights = function(colors, color)
          ---@type dracula.highlights
          return {
            ---@type vim.api.keyset.highlight
            Visual = { bg = "#2d3f76" },
            Search = { fg = colors.base0, bg = "#3e68d7" },
          }
        end,
        plugins = {
          ["nvim-treesitter"] = true,
          ["rainbow-delimiters"] = true,
          ["nvim-lspconfig"] = true,
          ["nvim-navic"] = true,
          ["nvim-cmp"] = true,
          ["indent-blankline.nvim"] = true,
          ["neo-tree.nvim"] = true,
          ["nvim-tree.lua"] = true,
          ["which-key.nvim"] = true,
          ["dashboard-nvim"] = true,
          ["gitsigns.nvim"] = true,
          ["neogit"] = true,
          ["todo-comments.nvim"] = true,
          ["lazy.nvim"] = true,
          ["telescope.nvim"] = true,
          ["noice.nvim"] = true,
          ["hop.nvim"] = true,
          ["mini.statusline"] = true,
          ["mini.tabline"] = true,
          ["mini.starter"] = true,
          ["mini.cursorword"] = true,
          ["bufferline.nvim"] = true,
        },
      })
    end,
  },

  {
    "ellisonleao/gruvbox.nvim",
  },

  {
    "loctvl842/monokai-pro.nvim",
    config = function()
      require("monokai-pro").setup({
        filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
      })
    end,
  },
}
