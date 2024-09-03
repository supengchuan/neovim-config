local wk = require("which-key")

local function get_visual()
  local _, ls, cs = unpack(vim.fn.getpos("v"))
  local _, le, ce = unpack(vim.fn.getpos("."))

  -- nvim_buf_get_text requires start and end args be in correct order
  ls, le = math.min(ls, le), math.max(ls, le)
  cs, ce = math.min(cs, ce), math.max(cs, ce)

  return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
end

function Toggle_wrap()
  local id = vim.api.nvim_get_current_win()

  if vim.wo[id].wrap == true then
    vim.wo[id].wrap = false
  else
    vim.wo[id].wrap = true
  end
end

function Toggle_inlay_hints()
  if vim.lsp.inlay_hint.is_enabled({}) then
    vim.lsp.inlay_hint.enable(false)
    print("Disable inlay hints")
  else
    vim.lsp.inlay_hint.enable(true)
    print("Enable inlay hints")
  end
end

--insert mode
wk.add({
  { "jj", "<ESC>", desc = "double j to normal mode", mode = "i" },
})
-- visual mode
wk.add({
  {
    "<leader>cs",
    function(opts)
      opts = opts or {}
      local current_path = vim.fn.expand("%")
      opts["search_dirs"] = { current_path }
      local visual = get_visual()
      local text = visual[1] or ""
      opts["default_text"] = text

      require("telescope").extensions.live_grep_args.live_grep_args(opts)
    end,
    desc = "search a string in visual block in current buffer",
    mode = "x",
  },
  {
    "<leader>s",
    function(opts)
      opts = opts or {}
      local visual = get_visual()
      local text = visual[1] or ""
      opts["default_text"] = text

      require("telescope").extensions.live_grep_args.live_grep_args(opts)
    end,
    desc = "search a string in visual block ",
    mode = "x",
  },
  {
    "ff",
    function()
      require("conform").format({ async = true }, function(err)
        if not err then
          local mode = vim.api.nvim_get_mode().mode
          if vim.startswith(string.lower(mode), "v") then
            print("range format and exit visual mode")
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
          end
        end
      end)
    end,
    desc = "range file format and leave visual mode",
    mode = "x",
  },
})
-- normal mode
wk.add({
  { "<C-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "go to definition" },
  { "<C-h>", "<cmd>NvimTmuxNavigateLeft<CR>", desc = "move cursor to left window" },
  { "<C-j>", "<cmd>NvimTmuxNavigateDown<CR>", desc = "move cursor to blow window" },
  { "<C-k>", "<cmd>NvimTmuxNavigateUp<CR>", desc = "move cursor to up window" },
  { "<C-l>", "<cmd>NvimTmuxNavigateRight<CR>", desc = "move cursor to right window" },
  { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "toggle folder tree on left" },
  { "F10", "<cmd>lua require'dap'.step_over()<CR>", desc = "debug step over" },
  { "F11", "<cmd>lua require'dap'.step_into()<CR>", desc = "debug step into" },
  { "F12", "<cmd>lua require'dap'.step_out()<CR>", desc = "debug step out" },
  { "F5", "<cmd>lua require'dap'.continue()<CR>", desc = "debug continue" },
  { "f", group = "format" },
  { "ff", "<cmd>Format<CR>", desc = "file format" },
  { "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "show lsp hint" },
  {
    "gi",
    "<cmd>lua require('telescope.builtin').lsp_implementations({layout_strategy= 'vertical', include_declaration = false, show_line = false})<CR>",
    desc = "go to implementations",
  },
  {
    "gr",
    "<cmd>lua require('telescope.builtin').lsp_references({layout_strategy= 'vertical', include_declaration = false, show_line = false})<CR>",
    desc = "go to references",
  },

  { "<leader>+", "<cmd>vertical resize -10<CR>", desc = "current buffer narrower" },
  { "<leader>-", "<cmd>lua require('oil').toggle_float()<cr>", desc = "open parent dir with oil" },
  { "<leader><CR>", Toggle_wrap, desc = "set file wrap or no wrap" },
  { "<leader>=", "<cmd>vertical resize +10<CR>", desc = "current buffer wider" },
  { "<leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", desc = "set a breakpoint" },
  {
    "<leader>cs",
    function(opts)
      opts = opts or {}
      local current_path = vim.fn.expand("%")
      opts["search_dirs"] = { current_path }
      local word_under_cursor = vim.fn.expand("<cword>")
      opts["default_text"] = word_under_cursor

      require("telescope").extensions.live_grep_args.live_grep_args(opts)
    end,
    desc = "search the word under cursor in current buffer",
  },
  { "<leader>d[", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "go to previous diagnostic" },
  { "<leader>d]", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "go to next diagnostic" },
  { "<leader>dd", "<cmd>Telescope diagnostics<CR>", desc = "list diagnostics via telescope" },
  { "<leader>e", "<cmd>lua require('telescope.builtin').buffers()<CR>", desc = "list open buffers" },
  { "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>", desc = "Find File" },
  { "<leader>gb", "<cmd>Gitsigns blame_line<CR>", desc = "blame line" },
  { "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", desc = "reset hunk" },
  { "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", desc = "stage hunk" },
  { "<leader>h", Toggle_inlay_hints, desc = "set a buffer enable inlay hints or not" },
  { "<leader>i", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "open diagnostic as float window" },
  {
    "<leader>im",
    "<cmd>lua require('telescope').extensions.goimpl.goimpl{initial_mode='insert'}<CR>",
    desc = "use goimpl to implement a interface fro struct",
  },
  { "<leader>j", "5j", desc = "move cursor down five lines" },
  { "<leader>k", "5k", desc = "move cursor up five lines" },
  {
    "<leader>lg",
    "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args({initial_mode = 'insert'})<cr>",
    desc = "live grep string",
  },
  { "<leader>nl", "<cmd>nohlsearch<CR>", desc = "cancel highlight for search" },
  { "<leader>o", "<cmd>AerialToggle<CR>", desc = "list current buffer outlines" },
  { "<leader>p", "<cmd>MarkdownPreviewToggle<CR>", desc = "preview markdown" },
  { "<leader>q", "<cmd>q<CR>", desc = "quit from current buffer" },
  { "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "rename token" },
  {
    "<leader>s",
    "<cmd>lua require('telescope.builtin').grep_string({initial_mode = 'insert'})<cr>",
    desc = "grep string",
  },
  { "<leader>w", "<cmd>w<CR>", desc = "save current buffer" },
  { "<leader>z", "<cmd>lua require('zen-mode').toggle({window = {width = 0.85}})<cr>", desc = "toggle zen mode" },
})
