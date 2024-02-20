local M = {
	"ggandor/leap.nvim",
	config = function()
		local status, leap = pcall(require, "leap")
		if not status then
			vim.notify("没有找到 leap")
			return
		end

		leap.add_default_mappings()
		leap.opts.case_sensitive = false
		leap.opts.highlight_unlabeled_phase_one_targets = true

		vim.keymap.set({ "x", "o", "n" }, "r", "<Plug>(leap-forward-to)")
		vim.keymap.set({ "x", "o", "n" }, "R", "<Plug>(leap-backward-to)")
	end,
}

return M
