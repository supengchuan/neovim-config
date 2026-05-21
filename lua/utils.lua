local utils = {}

local uv = vim.uv
local os_name = uv.os_uname().sysname
local is_windows = os_name == "Windows" or os_name == "Windows_NT" or os_name:find("MINGW")
local window_views = {}

function utils.GetVisual()
  local _, ls, cs = unpack(vim.fn.getpos("v"))
  local _, le, ce = unpack(vim.fn.getpos("."))

  -- nvim_buf_get_text requires start and end args be in correct order
  ls, le = math.min(ls, le), math.max(ls, le)
  cs, ce = math.min(cs, ce), math.max(cs, ce)

  return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
end

function utils.VisualLineMove(key)
  local mode = vim.api.nvim_get_mode().mode
  if vim.v.count > 0 or mode:sub(1, 2) == "no" or not vim.wo.wrap then
    return key
  end

  return "g" .. key
end

function utils.SetSoftWrapKeymaps(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  vim.keymap.set("n", "j", function()
    return utils.VisualLineMove("j")
  end, {
    buffer = bufnr,
    desc = "Move down",
    expr = true,
  })

  vim.keymap.set("n", "k", function()
    return utils.VisualLineMove("k")
  end, {
    buffer = bufnr,
    desc = "Move up",
    expr = true,
  })
end

function utils.IsolateWindow(win)
  win = win or vim.api.nvim_get_current_win()
  if not vim.api.nvim_win_is_valid(win) then
    return
  end

  if vim.wo[win].diff then
    return
  end

  if vim.wo[win].cursorbind then
    vim.wo[win].cursorbind = false
  end

  if vim.wo[win].scrollbind then
    vim.wo[win].scrollbind = false
  end
end

local function is_trackable_window(win)
  if not vim.api.nvim_win_is_valid(win) then
    return false
  end

  local config = vim.api.nvim_win_get_config(win)
  if config.relative ~= "" then
    return false
  end

  if vim.wo[win].diff then
    return false
  end

  local buf = vim.api.nvim_win_get_buf(win)
  local buftype = vim.bo[buf].buftype
  return buftype ~= "terminal" and buftype ~= "prompt" and buftype ~= "quickfix"
end

local function save_window_view(win)
  local info = vim.fn.getwininfo(win)[1]
  if not info then
    return nil
  end

  return {
    topline = info.topline or 1,
    topfill = 0,
    leftcol = info.leftcol or 0,
    skipcol = 0,
  }
end

local function restore_window_view(win, view)
  if not view then
    return
  end

  pcall(vim.api.nvim_win_call, win, function()
    vim.fn.winrestview({
      topline = view.topline,
      topfill = view.topfill,
      leftcol = view.leftcol,
      skipcol = view.skipcol,
    })
  end)
end

local function same_view(left, right)
  if not left or not right then
    return false
  end

  return left.topline == right.topline
    and left.leftcol == right.leftcol
    and left.skipcol == right.skipcol
    and left.topfill == right.topfill
end

function utils.RememberWindowView(win)
  win = win or vim.api.nvim_get_current_win()
  if not is_trackable_window(win) then
    window_views[win] = nil
    return
  end

  window_views[win] = save_window_view(win)
end

function utils.RememberAllWindowViews()
  local live_windows = {}

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    live_windows[win] = true
    utils.RememberWindowView(win)
  end

  for win in pairs(window_views) do
    if not live_windows[win] or not vim.api.nvim_win_is_valid(win) then
      window_views[win] = nil
    end
  end
end

function utils.RestoreNonCurrentWindowViews()
  if vim.g.local_restoring_window_views then
    return
  end

  vim.g.local_restoring_window_views = true

  local ok, err = pcall(function()
    local current_win = vim.api.nvim_get_current_win()

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if win ~= current_win and is_trackable_window(win) then
        local previous = window_views[win]
        local current = save_window_view(win)

        if previous and current and not same_view(current, previous) then
          restore_window_view(win, previous)
        elseif not previous then
          window_views[win] = current
        end
      end
    end

    utils.RememberWindowView(current_win)
    utils.IsolateEditorWindows()
  end)

  vim.g.local_restoring_window_views = false

  if not ok then
    vim.notify("restore window views failed: " .. tostring(err), vim.log.levels.WARN)
  end
end

function utils.IsolateEditorWindows()
  if vim.g.local_isolating_windows then
    return
  end

  vim.g.local_isolating_windows = true
  local ok, err = pcall(function()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local config = vim.api.nvim_win_get_config(win)
      if config.relative == "" then
        utils.IsolateWindow(win)
      end
    end
  end)
  vim.g.local_isolating_windows = false

  if not ok then
    vim.notify("isolate windows failed: " .. tostring(err), vim.log.levels.WARN)
  end
end

function utils.WindowBindStatus()
  local rows = {}

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    rows[#rows + 1] = string.format(
      "win=%s ft=%s scrollbind=%s cursorbind=%s diff=%s file=%s",
      win,
      vim.bo[buf].filetype ~= "" and vim.bo[buf].filetype or "-",
      tostring(vim.wo[win].scrollbind),
      tostring(vim.wo[win].cursorbind),
      tostring(vim.wo[win].diff),
      vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
    )
  end

  vim.notify(table.concat(rows, "\n"), vim.log.levels.INFO)
end

function utils.ToggleWrap()
  local id = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_get_current_buf()

  if vim.wo[id].wrap == true then
    vim.wo[id].wrap = false
    vim.notify("set current window to nowrap mode......", vim.log.levels.WARN)
  else
    vim.wo[id].wrap = true
    utils.SetSoftWrapKeymaps(bufnr)
    vim.notify("set current window to wrap mode......", vim.log.levels.WARN)
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
  return require("config.theme").current()
end

utils.GetColorschemeFromENV = utils.GetColorshemeFromENV

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
