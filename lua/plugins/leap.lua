local M = {
  "ggandor/leap.nvim",
  event = "VeryLazy",
  config = function()
    local status, leap = pcall(require, "leap")
    if not status then
      vim.notify("没有找到 leap")
      return
    end

    --leap.create_default_mappings()
    leap.opts.case_sensitive = false
    leap.opts.highlight_unlabeled_phase_one_targets = true

    vim.keymap.set({ "x", "o", "n" }, "r", "<Plug>(leap-forward-to)")
    vim.keymap.set({ "x", "o", "n" }, "R", "<Plug>(leap-backward-to)")
    vim.keymap.set({ "x", "o", "n" }, "gs", "<Plug>(leap-from-window)")
  end,
}

return M
