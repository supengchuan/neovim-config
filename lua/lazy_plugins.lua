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

--- for debug
--- @type string
local custom_plugin_path = vim.uv.os_homedir() .. "/code/neovim/vscode-high-contrast.nvim"
if vim.uv.fs_stat(custom_plugin_path) then
  spec = vim.list_extend(spec, { { dir = custom_plugin_path } })
end
--- end for debug

lazy.setup(spec, opts)
