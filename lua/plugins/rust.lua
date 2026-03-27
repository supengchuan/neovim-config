local M = {

  dependencies = {
    "saecki/crates.nvim",
    tag = "stable",
    config = function()
      require("crates").setup({})
    end,
  },
  "mrcjkb/rustaceanvim",
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
              -- 开启 experimental attribute completion
              snippets = "all",
              fullFunctionSignatures = {
                enable = true,
              },
              derive = {
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
