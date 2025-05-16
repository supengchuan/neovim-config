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
ensure_lazy()

-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

local lazy = require("lazy")

local opts = {
  ui = {
    border = "single",
  },
}

local spec = {
  {
    import = "plugins",
  },
}

--- NVIM_CUSTOM_PLUGIN is the env of the custom_plugin_path
local custom_plugin_path = os.getenv("NVIM_CUSTOM_PLUGIN")
if custom_plugin_path then
  if vim.uv.fs_stat(custom_plugin_path) then
    spec = vim.list_extend(spec, { { dir = custom_plugin_path } })
  end
end

lazy.setup(spec, opts)
