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

create_cmd("RunLab", function()
  require("modules.lab").work()
end, {})

create_cmd("WinNoBind", function()
  require("utils").IsolateEditorWindows()
  vim.notify("Disabled scrollbind/cursorbind in editor windows", vim.log.levels.INFO)
end, {})

create_cmd("WinBindStatus", function()
  require("utils").WindowBindStatus()
end, {})

create_cmd("PythonLspInfo", function()
  local lines = {}

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client.name == "pyright" or client.name == "ruff" then
      table.insert(lines, client.name .. " root: " .. (client.root_dir or "<single-file>"))

      if client.name == "pyright" then
        local settings = client.settings or client.config.settings or {}
        local python = settings.python or {}
        local analysis = python.analysis or {}

        table.insert(lines, "pythonPath: " .. (python.pythonPath or "<not set>"))
        table.insert(lines, "venv: " .. (python.venvPath and (python.venvPath .. "/" .. (python.venv or "")) or "<not set>"))
        table.insert(lines, "extraPaths: " .. table.concat(analysis.extraPaths or {}, ", "))
        table.insert(lines, "diagnosticMode: " .. (analysis.diagnosticMode or "<not set>"))
      end
    end
  end

  if #lines == 0 then
    vim.notify("No Python LSP client is attached to this buffer", vim.log.levels.INFO)
    return
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Python LSP" })
end, {})

create_cmd("DefSplit", function()
  require("fzf-lua").lsp_definitions({
    sync = true,
    jump1 = true,
    jump1_action = require("fzf-lua.actions").file_vsplit,
  })
end, {})

create_cmd("UnescapeJSON", function()
  -- Get current line under cursor
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]

  -- Extract the quoted string
  local json_str = line:match('"(.+)"')
  if not json_str then
    print("No quoted string found")
    return
  end

  -- Use vim.fn.json_decode to decode it
  local decoded = vim.fn.json_decode('"' .. json_str .. '"') -- Wrap again to decode properly

  -- Replace the line (or modify as needed)
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, { decoded })
end, {})

create_cmd("QuoteJSON", function()
  -- Get current line under cursor
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]

  -- json_encode returns a quoted string with escape characters
  local encoded = vim.fn.json_encode(line)

  -- Replace the line with the quoted string
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, { encoded })
end, {})
