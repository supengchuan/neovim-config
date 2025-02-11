return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    "s1n7ax/nvim-window-picker",
  },
  event = "VeryLazy",
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,
  opts = {},
  config = function()
    require("neo-tree").setup({
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      filesystem = {
        hijack_netrw_behavior = "disabled",
        -- open_default
        -- "open_current",
        -- "disabled",
        bind_to_cwd = false,
        follow_current_file = {
          enabled = true, -- This will find and focus the file in the active buffer every time
        },
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            ".git",
          },
        },
      },
      default_component_configs = {
        git_status = {
          symbols = {
            modified = "󰏫",
            ignored = "",
            unstaged = "",
          },
        },
        diagnostics = {
          symbols = {
            hint = " ",
            info = " ",
            warn = "󰈸",
            error = " ",
          },
        },
      },
      window = {
        mappings = {
          --["l"] = "open",
          ["h"] = "close_node",
          ["<CR>"] = "open",
          ["<space>"] = "none",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard",
          },
          ["O"] = {
            function(state)
              require("lazy.util").open(state.tree:get_node().path, { system = true })
            end,
            desc = "Open with System Application",
          },
          ["P"] = { "toggle_preview", config = { use_float = false } },
          ["<C-v>"] = "vsplit_with_window_picker",
        },
      },
    })
    vim.api.nvim_set_hl(0, "NeoTreeTitleBar", { link = "QuickFixLine" })
  end,
  keys = {
    { "<C-n>", "<cmd>Neotree toggle<CR>", desc = "toggle folder tree on left" },
  },
}
