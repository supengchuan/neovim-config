vim.api.nvim_set_keymap("n", "<leader>i", "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = true })
--vim.api.nvim_set_keymap("n", "<leader>d[", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { noremap = true, silent = true })
--vim.api.nvim_set_keymap("n", "<leader>d]", "<cmd>lua vim.diagnostic.goto_next()<CR>", { noremap = true, silent = true })
-- The following command requires plug-ins "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", and optionally "kyazdani42/nvim-web-devicons" for icon support
vim.api.nvim_set_keymap("n", "<leader>dd", "<cmd>Telescope diagnostics<CR>", { noremap = true, silent = true })
-- If you don't want to use the telescope plug-in but still want to see all the errors/warnings, comment out the telescope line and uncomment this:
-- vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- no useage
function PrintDiagnostics(opts, bufnr, line_nr, client_id)
	bufnr = bufnr or 0
	line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)
	opts = opts or { ["lnum"] = line_nr }

	local line_diagnostics = vim.diagnostic.get(bufnr, opts)
	if vim.tbl_isempty(line_diagnostics) then
		return
	end

	local diagnostic_message = ""
	for i, diagnostic in ipairs(line_diagnostics) do
		diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
		print(diagnostic_message)
		if i ~= #line_diagnostics then
			diagnostic_message = diagnostic_message .. "\n"
		end
	end
	vim.api.nvim_echo({ { diagnostic_message, "Normal" } }, false, {})
end

vim.diagnostic.config({
	virtual_text = {
		source = "always", -- Or "if_many"
		prefix = "●", -- Could be '■', '▎', 'x'
		spacing = 20,
	},
	severity_sort = true,
	float = {
		source = "always", -- Or "if_many"
		border = "rounded",
	},
})
