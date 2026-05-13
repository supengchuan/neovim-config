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

function M.setup()
  local common = require("filetypes.common")

  common.indent(4)
  common.text_width(120)
  setup_commands()

  vim.keymap.set("n", "<leader>pr", "<cmd>PyRunFile<cr>", { buffer = true, desc = "run python file" })
  vim.keymap.set("n", "<leader>pf", "<cmd>PyTestFile<cr>", { buffer = true, desc = "pytest current file" })
end

return M
