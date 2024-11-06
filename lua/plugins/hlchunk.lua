local M = {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
      chunk = {
        enable = true,
        delay = 0,
        chars = {
          horizontal_line = "─",
          vertical_line = "│",
          left_top = "╭",
          left_bottom = "╰",
          right_arrow = ">",
        },
        style = "#806d9c",
      },
      indent = {
        delay = 100,
        enable = true,
        use_treesitter = true,
        chars = {
          "▏",
          --"¦",
          --"│",
          --"┆",
          --"┊",
        },
        style = {
          "#e06c75",
          "#e5c07b",
          "#61afef",
          "#d19a66",
          "#98c379",
          "#c678dd",
          "#56b6c2",
        },
      },
      blank = {
        enable = false,
        chars = { "․" },
      },
    })
  end,
}

return M
