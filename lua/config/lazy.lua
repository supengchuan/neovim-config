local M = {}

local function ensure_lazy()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  vim.opt.rtp:prepend(lazypath)
end

function M.setup()
  if vim.g.nvim_lazy_setup_done then
    return
  end
  vim.g.nvim_lazy_setup_done = true

  ensure_lazy()

  local lazy = require("lazy")

  local opts = {
    install = {
      missing = vim.g.lazy_install_missing ~= false,
    },
    ui = {
      border = "single",
    },
  }

  local spec = {
    { import = "plugins.core" },
    { import = "plugins.ai" },
    { import = "plugins.coding" },
    { import = "plugins.editor" },
    { import = "plugins.lang" },
    { import = "plugins.tools" },
    { import = "plugins.ui" },
  }

  --- NVIM_CUSTOM_PLUGIN is the env of the custom_plugin_path
  local custom_plugin_path = os.getenv("NVIM_CUSTOM_PLUGIN")
  if custom_plugin_path then
    if vim.uv.fs_stat(custom_plugin_path) then
      spec = vim.list_extend(spec, { { dir = custom_plugin_path } })
    end
  end

  lazy.setup(spec, opts)
end

M.setup()

return M
