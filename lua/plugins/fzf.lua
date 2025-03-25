local M = {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "FzfLua",
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "echasnovski/mini.icons" },
  opts = function(_, opts)
    local fzf = require("fzf-lua")
    local config = fzf.config
    local actions = fzf.actions

    -- send search result to quickfix list
    config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
    config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
    config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
    config.defaults.keymap.fzf["ctrl-x"] = "jump"
    config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
    config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
    config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
    config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"
    return {
      winopts = {
        -- hide the falag h in title
        title_flags = false,
      },
    }
  end,
  keys = {
    { "<leader>e", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
    { "<leader>f", "<cmd>FzfLua files<cr>", desc = "Find files" },
    { "<leader>s", "<cmd>FzfLua live_grep<cr>", desc = "Search by live grep" },
    { "<leader>s", [[<cmd>FzfLua grep_visual<cr>]], mode = "x", desc = "Search visual words" },
    {
      "<C-]>",
      function()
        require("fzf-lua").lsp_definitions({ jump1 = true })
      end,
      desc = "Go to definition",
    },
    {
      "gr",
      function()
        require("fzf-lua").lsp_references({ jump1 = true, include_declaration = false })
      end,
      desc = "Go to references",
    },
    {
      "gi",
      function()
        require("fzf-lua").lsp_implementations()
      end,
      desc = "Go to implementations",
    },
    { "<leader>dd", [[fzf-lua diagnostics_document]], desc = "list document diagnostics" },
    { "<leader>dw", [[fzf-lua diagnostics_workspace]], desc = "list workspace diagnostics" },
  },
}

return M
