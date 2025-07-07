vim.api.nvim_create_user_command("NeoTreeGoRoot", function(opts)
  local Path = require("plenary.path")
  local current_file = vim.api.nvim_buf_get_name(0)
  local file_dir = vim.fn.fnamemodify(current_file, ":h")

  ---comment
  ---向上查找某个文件是否存在（如 go.mod 或 .git）
  ---@param start_path string
  ---@param target_name string
  local function find_upwards(start_path, target_name)
    local path = Path:new(start_path):absolute()
    while path and path ~= "/" do
      if
        vim.fn.isdirectory(path .. "/" .. target_name) == 1 or vim.fn.filereadable(path .. "/" .. target_name) == 1
      then
        return path
      end
      path = vim.fn.fnamemodify(path, ":h")
    end
    return nil
  end

  -- 优先查找 go.mod
  local project_root = find_upwards(file_dir, "go.mod") or find_upwards(file_dir, ".git")

  -- 如果没找到，再 fallback 到 .git
  if not project_root then
    vim.notify("❌ Failed to find go.mod or .git root", vim.log.levels.ERROR)
    return
  end

  local mode = opts.args
  if mode == nil or mode == "" then
    mode = "lcd"
  end
  if mode ~= "cd" and mode ~= "lcd" then
    vim.notify("❗Invalid argument: use 'cd' or 'lcd'", vim.log.levels.WARN)
    return
  end
  vim.cmd(mode .. " " .. project_root)

  vim.cmd("Neotree action=show source=filesystem reveal=true reveal_force_cwd=true")
  vim.notify("Neo-tree root set to: " .. project_root, vim.log.levels.INFO)
end, {
  nargs = "?",
  complete = function()
    return { "cd", "lcd" }
  end,
  desc = "Set Neo-tree root to Go project root or Git root",
})

vim.keymap.set("n", "<leader>gp", ":NeoTreeGoRoot lcd<CR>", { desc = "Neo-tree to Go root (lcd)" })
