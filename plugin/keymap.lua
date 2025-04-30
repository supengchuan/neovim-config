vim.keymap.set("n", "<leader>;", function()
  local line = vim.api.nvim_get_current_line()
  local trimmed = vim.trim(line)

  if trimmed ~= "" and not trimmed:match(";$") then
    -- Add semicolon only if line is not empty and doesn't already have one
    line = line:gsub("%s*$", ";")
    vim.api.nvim_set_current_line(line)
  end

  vim.cmd("startinsert")

  -- Simulate <CR> to create a new line and enter insert mode with correct indent
  vim.cmd("startinsert!") -- Enter insert mode after the line is opened
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
end, { desc = "Add semicolon if needed and open new line" })
