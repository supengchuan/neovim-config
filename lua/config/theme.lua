local M = {}

M.default = "onedark"
M.fallback = "tokyonight"

M.available = {
  "onedark",
  "tokyonight",
  "catppuccin",
  "dracula",
  "gruvbox",
  "everforest",
  "cyberdream",
  "rusty",
  "vscode_hc_dark",
}

local plugin_by_theme = {
  catppuccin = "catppuccin",
  cyberdream = "cyberdream.nvim",
  dracula = "dracula.nvim",
  everforest = "everforest-nvim",
  gruvbox = "gruvbox.nvim",
  onedark = "onedark.nvim",
  rusty = "rusty",
  tokyonight = "tokyonight.nvim",
}

function M.current()
  return vim.g.nvim_theme or os.getenv("NVIM_COLOR") or M.default
end

local function load_theme_plugin(name)
  local plugin = plugin_by_theme[name]
  if not plugin then
    return
  end

  local ok, lazy = pcall(require, "lazy")
  if ok then
    pcall(lazy.load, { plugins = { plugin } })
  end
end

---@param name string
local function has_colorscheme(name)
  return vim.tbl_contains(vim.fn.getcompletion(name, "color"), name)
end

---@param name string?
function M.apply(name)
  name = name or M.current()
  load_theme_plugin(name)

  if not has_colorscheme(name) and name ~= M.fallback then
    vim.notify("colorscheme `" .. name .. "` is not installed; fallback to `" .. M.fallback .. "`", vim.log.levels.WARN)
    name = M.fallback
    load_theme_plugin(name)
  end

  local ok, err = pcall(vim.cmd.colorscheme, name)

  if not ok then
    local message = string.format("colorscheme `%s` failed: %s", name, err)
    if name ~= M.fallback then
      vim.notify(message .. "; fallback to `" .. M.fallback .. "`", vim.log.levels.WARN)
      pcall(vim.cmd.colorscheme, M.fallback)
    else
      vim.notify(message, vim.log.levels.ERROR)
    end
  end

  vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
end

function M.setup()
  vim.api.nvim_create_user_command("Theme", function(opts)
    local theme = opts.args ~= "" and opts.args or nil
    if theme then
      vim.g.nvim_theme = theme
    end
    M.apply(theme)
  end, {
    nargs = "?",
    force = true,
    complete = function()
      return M.available
    end,
    desc = "Switch colorscheme. Example: :Theme catppuccin",
  })
end

return M
