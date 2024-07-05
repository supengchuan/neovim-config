require("basic")
require("lazy_plugins")

require("wk")
require("format")

--cmp
require("cmp-config")
--lsp
--require("lsp-config")

require("diagnostics")

-- debug
require("dap-config")

-- autocmd
require("autocmd")

--latex
require("tex")

-- set bg transparent
--require("highlight")

-- set colorscheme at last
local function getColorshemeFromENV()
	local scheme = "tokyonight"
	local fromENV = os.getenv("NVIM-COLOR")
	if fromENV ~= nil then
		scheme = fromENV
	end

	return scheme
end

vim.cmd.colorscheme(getColorshemeFromENV())
