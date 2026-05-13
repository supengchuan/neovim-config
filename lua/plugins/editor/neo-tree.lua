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
  cmd = "Neotree",
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,
  opts = {},
  config = function()
    local function highlight_value(group, key, fallback)
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
      if ok and type(hl[key]) == "number" then
        return string.format("#%06x", hl[key])
      end

      return fallback
    end

    local function apply_neotree_highlights()
      local normal_fg = highlight_value("Normal", "fg", "#abb2bf")
      local normal_bg = highlight_value("Normal", "bg", "#1e222a")
      local git_highlights = {
        "NeoTreeGitAdded",
        "NeoTreeGitConflict",
        "NeoTreeGitDeleted",
        "NeoTreeGitIgnored",
        "NeoTreeGitModified",
        "NeoTreeGitRenamed",
        "NeoTreeGitStaged",
        "NeoTreeGitUnstaged",
        "NeoTreeGitUntracked",
      }

      vim.api.nvim_set_hl(0, "NeoTreeNormal", { fg = normal_fg, bg = normal_bg })
      vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { fg = normal_fg, bg = normal_bg })
      vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { fg = normal_bg, bg = normal_bg })
      vim.api.nvim_set_hl(0, "NeoTreeStatusSpacer", { fg = normal_bg, bg = normal_bg })

      for _, group in ipairs(git_highlights) do
        local fallback = group == "NeoTreeGitUntracked" and "#E5C07B" or normal_fg
        vim.api.nvim_set_hl(0, group, {
          fg = highlight_value(group, "fg", fallback),
          bg = normal_bg,
          bold = false,
          italic = false,
        })
      end
    end

    local function apply_neotree_window_options()
      vim.opt_local.colorcolumn = ""
      vim.opt_local.cursorbind = false
      vim.opt_local.cursorcolumn = false
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.fillchars = "eob: "
      vim.opt_local.list = false
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.scrollbind = false
      vim.opt_local.signcolumn = "no"
      vim.opt_local.spell = false
      vim.opt_local.winhl = table.concat({
        "Normal:NeoTreeNormal",
        "NormalNC:NeoTreeNormalNC",
        "EndOfBuffer:NeoTreeEndOfBuffer",
        "SignColumn:NeoTreeNormal",
      }, ",")
      vim.opt_local.wrap = false
    end

    local redraw_timer = nil

    local function redraw_if_neotree_visible()
      if redraw_timer then
        return
      end

      redraw_timer = vim.defer_fn(function()
        redraw_timer = nil

        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "neo-tree" then
            vim.api.nvim_win_call(win, apply_neotree_window_options)
            vim.cmd("redraw!")
            return
          end
        end
      end, 16)
    end

    require("neo-tree").setup({
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      enable_diagnostics = false,
      git_status_async = false,
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = apply_neotree_window_options,
        },
        {
          event = "after_render",
          handler = redraw_if_neotree_visible,
        },
      },
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
        container = {
          enable_character_fade = false,
          right_padding = 0,
          width = "100%",
        },
        name = {
          use_filtered_colors = true,
          use_git_status_colors = true,
        },
        git_status = {
          symbols = {
            ignored = "",
            modified = "󰏫",
            unstaged = "",
            untracked = "?",
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
      commands = {
        yank_file_path = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          vim.fn.setreg("+", path, "c")
        end,
        open_with_sys_app = function(state)
          require("lazy.util").open(state.tree:get_node().path, { system = true })
        end,
      },
      window = {
        mappings = {
          --["l"] = "open",
          ["h"] = "close_node",
          ["<CR>"] = "open",
          ["<space>"] = "none",
          ["Y"] = "yank_file_path",
          ["O"] = "open_with_sys_app",
          ["P"] = { "toggle_preview", config = { use_float = false } },
          ["<C-v>"] = "vsplit_with_window_picker",
        },
      },
    })
    vim.api.nvim_set_hl(0, "NeoTreeTitleBar", { link = "QuickFixLine" })
    apply_neotree_highlights()

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("LocalNeoTreeHighlights", { clear = true }),
      callback = apply_neotree_highlights,
      desc = "Keep Neo-tree git status highlights readable",
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("LocalNeoTreeWindowOptions", { clear = true }),
      pattern = "neo-tree",
      callback = apply_neotree_window_options,
      desc = "Keep Neo-tree window rendering isolated",
    })

    vim.api.nvim_create_autocmd({ "WinScrolled", "WinResized" }, {
      group = vim.api.nvim_create_augroup("LocalNeoTreeRedraw", { clear = true }),
      callback = redraw_if_neotree_visible,
      desc = "Clear stale Neo-tree right-aligned status cells",
    })
  end,
  keys = {
    { "<C-n>", "<cmd>Neotree toggle<CR>", desc = "toggle folder tree on left" },
    { "<leader>ee", "<cmd>Neotree toggle<CR>", desc = "toggle file tree" },
  },
}
