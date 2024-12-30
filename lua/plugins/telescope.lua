local M = {
  "nvim-telescope/telescope.nvim",
  version = "0.1.x",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- improve telescope performance
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    -- look environment variables with telescope
    "LinArcX/telescope-env.nvim",
    -- Project need
    "nvim-telescope/telescope-project.nvim",
    -- telesocpe-dap
    "nvim-telescope/telescope-dap.nvim",
    -- goimpl in telescope
    "edolphin-ydf/goimpl.nvim",
    -- make live grep support args
    "nvim-telescope/telescope-live-grep-args.nvim",
    -- quick diff two file
    "jemag/telescope-diff.nvim",
  },
  config = function()
    local status, telescope = pcall(require, "telescope")
    if not status then
      vim.notify("没有找到 telescope")
      return
    end

    local lga_actions = require("telescope-live-grep-args.actions")

    telescope.setup({
      defaults = {
        --prompt_prefix = "",
        -- 打开弹窗后进入的初始模式，默认为 normal，也可以是 insert
        initial_mode = "normal",

        layout_strategy = "vertical",
        layout_config = {
          height = 0.95,
          width = 0.95,
        },

        mappings = {
          n = {
            ["q"] = "close",
            ["<c-d>"] = require("telescope.actions").delete_buffer,
          },
        },
      },
      pickers = {
        buffers = {
          ignore_current_buffer = true,
          sort_mru = true,
        },
        find_files = {
          initial_mode = "insert",
        },
      },
      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
        },
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
          mappings = { -- extend mappings
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
            },
          },
        },
      },
    })

    telescope.load_extension("live_grep_args")
    -- To get fzf loaded and working with telescope, you need to call
    -- load_extension, somewhere after setup function:
    telescope.load_extension("fzf")
    -- extension telescope-env.nvim
    telescope.load_extension("env")
    -- extension telescope-project
    telescope.load_extension("project")
    -- extension telescope-dap
    telescope.load_extension("dap")
    -- extension goimpl
    telescope.load_extension("goimpl")
    -- diff
    telescope.load_extension("diff")
  end,
}

return M
