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

    local blocked_picker_filetypes = {
      ["neo-tree"] = true,
      ["neo-tree-popup"] = true,
      notify = true,
      snacks_notif = true,
      oil = true,
      Trouble = true,
      trouble = true,
      qf = true,
      Outline = true,
    }

    local blocked_picker_buftypes = {
      help = true,
      nofile = true,
      prompt = true,
      quickfix = true,
      terminal = true,
    }

    local function isolate_window(win)
      require("utils").IsolateWindow(win)
    end

    local function is_edit_window(win)
      if not vim.api.nvim_win_is_valid(win) or win == vim.api.nvim_get_current_win() then
        return false
      end

      local config = vim.api.nvim_win_get_config(win)
      if config.relative ~= "" or config.focusable == false then
        return false
      end

      local buf = vim.api.nvim_win_get_buf(win)
      if blocked_picker_filetypes[vim.bo[buf].filetype] or blocked_picker_buftypes[vim.bo[buf].buftype] then
        return false
      end

      return true
    end

    local function pick_edit_window()
      local candidates = {}
      local candidate_set = {}

      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if is_edit_window(win) then
          candidates[#candidates + 1] = win
          candidate_set[win] = true
        end
      end

      if #candidates == 0 then
        vim.notify("No editable window available for vertical split", vim.log.levels.WARN)
        return nil
      end

      if #candidates == 1 then
        return candidates[1]
      end

      return require("window-picker").pick_window({
        filter_func = function(windows)
          return vim.tbl_filter(function(win)
            return candidate_set[win] == true
          end, windows)
        end,
      })
    end

    local function open_vsplit_with_window_picker(state)
      local node = state.tree:get_node()
      if not node or node.type == "message" then
        return
      end

      if node.type == "directory" then
        require("neo-tree.sources.filesystem.commands").toggle_node(state)
        return
      end

      local path = node.path or node:get_id()
      if type(path) ~= "string" or path == "" then
        return
      end

      local target_win = pick_edit_window()
      if not target_win or not vim.api.nvim_win_is_valid(target_win) then
        return
      end

      local events = require("neo-tree.events")
      local event_result = events.fire_event(events.FILE_OPEN_REQUESTED, {
        state = state,
        path = path,
        open_cmd = "vsplit",
      }) or {}

      if event_result.handled then
        events.fire_event(events.FILE_OPENED, path)
        return
      end

      isolate_window(target_win)
      vim.api.nvim_set_current_win(target_win)

      local ok, err = pcall(vim.cmd, "vsplit " .. vim.fn.fnameescape(path))
      if not ok then
        vim.notify("Failed to open vertical split: " .. tostring(err), vim.log.levels.ERROR)
        return
      end

      local new_win = vim.api.nvim_get_current_win()
      vim.bo.buflisted = true
      isolate_window(target_win)
      isolate_window(new_win)
      require("utils").IsolateEditorWindows()
      vim.schedule(function()
        isolate_window(target_win)
        isolate_window(new_win)
        require("utils").IsolateEditorWindows()
      end)
      events.fire_event(events.FILE_OPENED, path)
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
          right_padding = 1,
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
        vsplit_with_isolated_window_picker = open_vsplit_with_window_picker,
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
          ["<C-v>"] = "vsplit_with_isolated_window_picker",
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

  end,
  keys = {
    { "<C-n>", "<cmd>Neotree toggle<CR>", desc = "toggle folder tree on left" },
    { "<leader>ee", "<cmd>Neotree toggle<CR>", desc = "toggle file tree" },
  },
}
