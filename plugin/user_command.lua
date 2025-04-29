local create_cmd = vim.api.nvim_create_user_command

create_cmd("ClearX", function()
  vim.fn.setreg("+", "")
  vim.fn.setreg("*", "")
end, {})

create_cmd("CWD", function()
  local current_buffer_dir = vim.fn.expand("%:p:h")
  vim.api.nvim_set_current_dir(current_buffer_dir)
end, {})

create_cmd("FoldEnable", function()
  -- set fold
  vim.opt.foldmethod = "expr"
  vim.opt.foldlevel = 99 -- value 99 almost means do not fold any text when opening a file, just means open all folds
  vim.opt.foldlevelstart = 99
  vim.opt.foldenable = true
  vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.opt.foldtext = require("modules.foldtext")
end, {})
