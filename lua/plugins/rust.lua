local M = {
  "mrcjkb/rustaceanvim",
  version = "^5", -- Recommended
  ft = { "rust" },
  config = function()
    vim.g.rustaceanvim = {
      tools = {
        float_win_config = {
          auto_focus = true,
          border = {
            { "╭", "FloatBorder" },
            { "─", "FloatBorder" },
            { "╮", "FloatBorder" },
            { "│", "FloatBorder" },
            { "╯", "FloatBorder" },
            { "─", "FloatBorder" },
            { "╰", "FloatBorder" },
            { "│", "FloatBorder" },
          },
        },
      },

      server = {
        standalone = false,
        default_settings = {
          ["rust-analyzer"] = {
            completion = {
              fullFunctionSignatures = {
                enable = true,
              },
            },
          },
        },
      },
    }
  end,
}
return M
