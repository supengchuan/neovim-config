local M = {}

local function python_bin()
  local python = vim.fn.exepath("python3")
  if python ~= "" then
    return vim.fn.shellescape(python)
  end
  return "python"
end

local function setup_commands()
  vim.api.nvim_create_user_command("PyRunFile", function()
    vim.cmd("write")
    local file = vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
    vim.cmd("botright split | terminal " .. python_bin() .. " " .. file)
  end, { desc = "Run current python file", force = true })

  vim.api.nvim_create_user_command("PyTestFile", function()
    vim.cmd("write")
    local file = vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
    vim.cmd("botright split | terminal pytest " .. file)
  end, { desc = "Run pytest for current python file", force = true })
end

local function setup_black_compatible_indent()
  vim.g.python_indent = vim.tbl_deep_extend("force", vim.g.python_indent or {}, {
    closed_paren_align_last_line = false,
    continue = "shiftwidth()",
    nested_paren = "shiftwidth()",
    open_paren = "shiftwidth()",
  })
end

local python_pairs = {
  ["("] = ")",
  ["["] = "]",
  ["{"] = "}",
}

local function termcodes(keys)
  return vim.api.nvim_replace_termcodes(keys, true, false, true)
end

local function python_insert_cr()
  local ok_cmp, cmp = pcall(require, "blink.cmp")
  if ok_cmp and cmp.is_visible and cmp.is_visible() and cmp.accept() then
    return ""
  end

  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local before = line:sub(1, col)
  local after = line:sub(col + 1)
  local opener = before:sub(-1)
  local closer = after:sub(1, 1)

  if python_pairs[opener] == closer then
    return termcodes("<C-g>u<CR><Esc>O")
  end

  local ok_pairs, npairs = pcall(require, "nvim-autopairs")
  if ok_pairs then
    return npairs.autopairs_cr()
  end

  return termcodes("<CR>")
end

local function setup_python_enter_keymap()
  local function set_keymap()
    vim.keymap.set("i", "<CR>", python_insert_cr, {
      buffer = true,
      desc = "python newline with formatter-like pair indent",
      expr = true,
      noremap = true,
      replace_keycodes = false,
      silent = true,
    })
  end

  set_keymap()

  if vim.b.local_python_enter_autocmd then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  vim.b.local_python_enter_autocmd = vim.api.nvim_create_autocmd("InsertEnter", {
    buffer = bufnr,
    group = vim.api.nvim_create_augroup("LocalPythonEnter", { clear = false }),
    callback = function()
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          set_keymap()
        end
      end)
    end,
  })
end

local function remove_python_type_annotation_reindent()
  local keys = vim.split(vim.bo.indentkeys, ",", { plain = true, trimempty = true })
  local filtered = {}
  local blocked = {
    [":"] = true,
    ["<:>"] = true,
  }

  for _, key in ipairs(keys) do
    if not blocked[key] then
      filtered[#filtered + 1] = key
    end
  end

  vim.bo.indentkeys = table.concat(filtered, ",")
end

function M.setup()
  local common = require("filetypes.common")

  setup_black_compatible_indent()
  common.indent(4)
  common.text_width(120)
  setup_commands()
  setup_python_enter_keymap()

  vim.schedule(function()
    if vim.bo.filetype == "python" then
      remove_python_type_annotation_reindent()
    end
  end)

  vim.keymap.set("n", "<leader>pr", "<cmd>PyRunFile<cr>", { buffer = true, desc = "run python file" })
  vim.keymap.set("n", "<leader>pf", "<cmd>PyTestFile<cr>", { buffer = true, desc = "pytest current file" })
end

return M
