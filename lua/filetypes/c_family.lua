local M = {}

local function run_clangd_command(command, label)
  return function()
    local ok, err = pcall(vim.cmd, command)
    if ok then
      return
    end

    vim.notify(label .. " requires an attached clangd client: " .. tostring(err), vim.log.levels.WARN)
  end
end

function M.setup()
  local common = require("filetypes.common")

  common.indent(4)
  common.text_width(120)

  vim.keymap.set(
    "n",
    "<leader>cH",
    run_clangd_command("LspClangdSwitchSourceHeader", "Switch source/header"),
    { buffer = true, desc = "switch source/header" }
  )

  vim.keymap.set(
    "n",
    "<leader>cS",
    run_clangd_command("LspClangdShowSymbolInfo", "Show clangd symbol info"),
    { buffer = true, desc = "show clangd symbol info" }
  )
end

return M
