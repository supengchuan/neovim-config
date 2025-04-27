local create_cmd = vim.api.nvim_create_user_command

create_cmd("ClearX", function()
  vim.fn.setreg("+", "")
  vim.fn.setreg("*", "")
end, {})

create_cmd("CWD", function()
  local current_buffer_dir = vim.fn.expand("%:p:h")
  vim.api.nvim_set_current_dir(current_buffer_dir)
end, {})
