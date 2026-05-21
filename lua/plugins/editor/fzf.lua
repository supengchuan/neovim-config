local function reveal_cursor_near_top()
  vim.cmd("normal! zv")

  local win = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(win)
  local view = vim.fn.winsaveview()
  local scrolloff = math.min(vim.wo[win].scrolloff, 3)

  vim.wo[win].scrolloff = scrolloff
  view.topline = math.max(cursor[1] - scrolloff, 1)
  vim.fn.winrestview(view)
end

local function jump_to_location_item(item)
  local from = vim.fn.getpos(".")
  from[1] = vim.api.nvim_get_current_buf()

  vim.cmd("normal! m'")
  vim.fn.settagstack(vim.fn.win_getid(), {
    items = {
      {
        tagname = vim.fn.expand("<cword>"),
        from = from,
      },
    },
  }, "t")

  local bufnr = item.bufnr or vim.fn.bufadd(item.filename)
  vim.bo[bufnr].buflisted = true

  local win = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_buf(win) ~= bufnr then
    local existing_win = vim.fn.bufwinid(bufnr)
    if existing_win >= 0 then
      win = existing_win
      vim.api.nvim_set_current_win(win)
    else
      vim.api.nvim_win_set_buf(win, bufnr)
    end
  end

  vim.api.nvim_win_set_cursor(win, { item.lnum, math.max((item.col or 1) - 1, 0) })
  reveal_cursor_near_top()
end

local function definition_on_list(options)
  if #options.items == 1 then
    jump_to_location_item(options.items[1])
    return
  end

  vim.fn.setqflist({}, " ", options)
  vim.cmd("botright copen")
end

local function go_to_definition()
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client:supports_method("textDocument/definition") then
      vim.lsp.buf.definition({ reuse_win = true, on_list = definition_on_list })
      return
    end
  end

  local ctrl_right_bracket = vim.api.nvim_replace_termcodes("<C-]>", true, false, true)
  vim.api.nvim_feedkeys(ctrl_right_bracket, "n", false)
  vim.defer_fn(reveal_cursor_near_top, 20)
end

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

    -- send search result to quickfix list
    config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
    config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
    config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
    config.defaults.keymap.fzf["ctrl-x"] = "jump"
    config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
    config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
    config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
    config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"
    config.defaults.keymap.builtin["<F12>"] = "toggle-preview"
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
      grep = {
        prompt = "Rg❯ ",
        input_prompt = "Grep For❯ ",
      },
      lsp = {
        -- 使用异步的调用 lsp 的 method，它默认时 5000ms，
        -- 但是在go中的一些 go-to-implementations 时会超时，我将它设置为 异步
        async_or_timeout = true,
      },
    }
  end,
  keys = {
    {
      "<leader>fb",
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
      "<leader>ff",
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
    { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Search by live grep" },
    { "<leader>fg", [[<cmd>FzfLua grep_visual<cr>]], mode = "x", desc = "Search visual words" },
    {
      "<leader>fd",
      function()
        require("fzf-lua").diagnostics_workspace()
      end,
      desc = "list workspace diagnostics",
    },
    {
      "<C-]>",
      go_to_definition,
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
        require("fzf-lua").lsp_implementations({ ignore_current_line = true })
      end,
      desc = "Go to implementations",
    },
  },
}

return M
