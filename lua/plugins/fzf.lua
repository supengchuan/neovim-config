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
        height = 1,
        width = 0.98,
        backdrop = 90,
        -- hide the falg h in title
        title_flags = false,
      },
      fzf_opts = {
        ["--cycle"] = true,
      },
    }
  end,
  keys = {
    {
      "<leader>e",
      function()
        require("fzf-lua").buffers({
          winopts = {
            height = vim.o.lines > 30 and 0.5 or 0.8,
            width = vim.o.columns > 90 and 0.65 or 0.85,
            preview = { hidden = true },
          },
        })
      end,
      desc = "Switch Buffer",
    },
    {
      "<leader>f",
      function()
        require("fzf-lua").files({
          winopts = {
            fullscreen = true,
            preview = {
              hidden = vim.o.columns < 80 and true or false,
            },
          },
        })
      end,
      desc = "Find files",
    },
    { "<leader>s", "<cmd>FzfLua live_grep<cr>", desc = "Search by live grep" },
    { "<leader>s", [[<cmd>FzfLua grep_visual<cr>]], mode = "x", desc = "Search visual words" },
    {
      "<leader>d",
      function()
        require("fzf-lua").diagnostics_workspace()
      end,
      desc = "list workspace diagnostics",
    },
    {
      "<C-]>",
      function()
        require("fzf-lua").lsp_definitions({ jump1 = true, ignore_current_line = true })
      end,
      desc = "Go to definition",
    },
    {
      "gr",
      function()
        require("fzf-lua").lsp_references({ ignore_current_line = true, jump1 = true, includeDeclaration = false })
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
  },
}

return M
