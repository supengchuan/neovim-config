vim.keymap.set("n", "<leader>c;", function()
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

---@param next boolean
local function choose_quickfix(next)
  local cmd = "cnext"
  local position = "bottom"
  if not next then
    cmd = "cprev"
    position = "top"
  end

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
    if buftype == "quickfix" then
      ---@type boolean, string?
      local ok, err = pcall(function()
        vim.cmd(cmd)
      end)
      if not ok then
        if err and string.match(err, "E553") then
          vim.notify("You're already at the " .. position .. " of quickfix item", vim.log.levels.INFO)
        elseif err then
          vim.notify("chose quickfix error: " .. err, vim.log.levels.WARN)
        else
          vim.notify("chose quickfix error: unknown error", vim.log.levels.ERROR)
        end
      end
      return
    end
  end

  vim.notify("Quickfix window is not open", vim.log.levels.INFO)
end

vim.keymap.set("n", "]q", function()
  choose_quickfix(true)
end, { silent = true, desc = "next quickfix item" })

vim.keymap.set("n", "[q", function()
  choose_quickfix(false)
end, { silent = true, desc = "previous quickfix item" })
