local M = {}
function M.Get_visual()
  local _, ls, cs = unpack(vim.fn.getpos("v"))
  local _, le, ce = unpack(vim.fn.getpos("."))

  -- nvim_buf_get_text requires start and end args be in correct order
  ls, le = math.min(ls, le), math.max(ls, le)
  cs, ce = math.min(cs, ce), math.max(cs, ce)

  return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
end

function M.Toggle_wrap()
  local id = vim.api.nvim_get_current_win()

  if vim.wo[id].wrap == true then
    vim.wo[id].wrap = false
  else
    vim.wo[id].wrap = true
  end
end

function M.Toggle_inlay_hints()
  if vim.lsp.inlay_hint.is_enabled({}) then
    vim.lsp.inlay_hint.enable(false)
    print("Disable inlay hints")
  else
    vim.lsp.inlay_hint.enable(true)
    print("Enable inlay hints")
  end
end

function M.getColorshemeFromENV()
  local scheme = "tokyonight"
  local fromENV = os.getenv("NVIM_COLOR")
  if fromENV ~= nil then
    scheme = fromENV
  end

  return scheme
end

return M
