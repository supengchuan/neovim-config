---- auto install packer if packer did not isntalled
--local ensure_packer = function()
--	local fn = vim.fn
--	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
--	if fn.empty(fn.glob(install_path)) > 0 then
--		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
--		vim.cmd([[packadd packer.nvim]])
--		return true
--	end
--	return false
--end
--ensure_packer()

local function bootstrap_pckr()
  local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"
  if not vim.loop.fs_stat(pckr_path) then
    vim.fn.system({
      'git',
      'clone',
      "--filter=blob:none",
      'https://github.com/lewis6991/pckr.nvim',
      pckr_path
    })
  end

  vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

require("pckr_plugins")
require("basic")
--require("plugins")
require("keybindings")
require("format")

--cmp
require("cmp-config")
--lsp
require("lsp-config")

-- plugin-config
require("plugin-config")

-- debug
require("dap-config")

-- autocmd
require("autocmd")

-- colorscheme
require("colorscheme")

--latex
require("tex")

-- set bg transparent
vim.cmd([[highlight Normal ctermbg=NONE guibg=NONE guifg=NONE ]])
vim.cmd([[highlight NormalFloat ctermbg=NONE guibg=NONE]])
vim.cmd([[highlight SignColumn ctermbg=NONE guibg=NONE]])
vim.cmd([[highlight NvimTreeNormal guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight BufferLineFill guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight BufferLineBufferSelected guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight TelescopeNormal guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight Pmenu guibg=NONE]])
vim.cmd([[highlight CmpItemAbbrMatch guibg=NONE]])
vim.cmd([[highlight FloatShadow guibg=NONE]])
