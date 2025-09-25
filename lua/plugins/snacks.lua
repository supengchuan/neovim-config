local M = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    input = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    words = { enabled = true },
    debug = { enabled = true },
    picker = { enabled = true },
    dashboard = {
      enabled = true,
      formats = {
        key = function(item)
          return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
        end,
      },
      sections = {
        { section = "header" },
        { section = "startup", padding = 1 },
        { title = "Files", padding = 1 },
        { section = "recent_files", padding = 1 },
        { title = "Projects", padding = 1 },
        { section = "projects", padding = 1 },
        { title = "Bookmarks", padding = 1 },
        { icon = " ", section = "keys" },
      },
    },
    notifier = { enabled = true }, -- noice may be use this
    lazygit = {
      win = {
        width = 0,
        height = 0,
      },
    },
    statuscolumn = {
      -- 它是 number column 左右的column
      -- left 表示的是 number column 的左边
      enabled = true,
      folds = {
        open = true,
        git_hl = true,
      },
    },
    styles = {
      terminal = {
        keys = {
          ["<esc>"] = "hide",
        },
      },
    },
  },
  keys = {
    {
      "<leader>t",
      function()
        Snacks.terminal()
      end,
      desc = "toggle terminal",
    },
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "lazygit toggle",
    },
  },
}

return M
