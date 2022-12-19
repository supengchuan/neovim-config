local function clangd_formater()
	return {
		exe = "clang-format",
		args = {
			'--style="{BasedOnStyle: llvm, IndentWidth: 4}"',
		},
		stdin = true,
	}
end

local function proto_formater()
	return {
		exe = "clang-format",
		args = {
			"--style=google",
		},
		stdin = true,
	}
end

require("formatter").setup({
	logging = false,
	filetype = {
		markdown = {
			require("formatter.filetypes.markdown").prettier,
		},
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
		rust = {
			function()
				return {
					exe = "rustfmt",
					args = { "--emit=stdout" },
					stdin = true,
				}
			end,
		},
		sql = {
			function()
				return {
					exe = "sql-formatter",
					args = { "-l mysql" },
					stdin = true,
				}
			end,
		},
		go = {
			require("formatter.filetypes.go").goimports,
		},
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		cpp = {
			clangd_formater(),
		},
		proto = {
			proto_formater(),
		},
		c = {
			clangd_formater(),
		},
		json = {
			require("formatter.filetypes.json").prettier,
		},
		sh = {
			require("formatter.filetypes.sh").shfmt,
		},
	},
})
