local utils = {}

local uv = vim.uv
local os_name = uv.os_uname().sysname
local is_windows = os_name == "Windows" or os_name == "Windows_NT" or os_name:find("MINGW")

function utils.GetVisual()
  local _, ls, cs = unpack(vim.fn.getpos("v"))
  local _, le, ce = unpack(vim.fn.getpos("."))

  -- nvim_buf_get_text requires start and end args be in correct order
  ls, le = math.min(ls, le), math.max(ls, le)
  cs, ce = math.min(cs, ce), math.max(cs, ce)

  return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
end

function utils.ToggleWrap()
  local id = vim.api.nvim_get_current_win()

  if vim.wo[id].wrap == true then
    vim.wo[id].wrap = false
    if vim.fn.mapcheck("j", "n") ~= "" then
      vim.api.nvim_del_keymap("n", "j")
      vim.api.nvim_del_keymap("n", "k")
      vim.api.nvim_echo({ { "norwap, and j, k mode" } }, false, {})
    end
  else
    vim.wo[id].wrap = true
    if vim.fn.mapcheck("j", "n") == "" then
      local map = vim.keymap.set
      map("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
      map("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
      vim.api.nvim_echo({ { "set wrap, gj, gk mode" } }, false, {})
    end
  end
end

function utils.ToggleInlayHints()
  if vim.lsp.inlay_hint.is_enabled({}) then
    vim.lsp.inlay_hint.enable(false)
    print("Disable inlay hints")
  else
    vim.lsp.inlay_hint.enable(true)
    print("Enable inlay hints")
  end
end

function utils.GetColorshemeFromENV()
  local scheme = "tokyonight"
  local fromENV = os.getenv("NVIM_COLOR")
  if fromENV ~= nil then
    scheme = fromENV
  end

  return scheme
end

function utils.Sep()
  if is_windows then
    return "\\"
  end
  return "/"
end

function utils.IsWindows()
  return is_windows
end
return utils
