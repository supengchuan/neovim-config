vim.diagnostic.config({
  virtual_text = false,
  -- virtual_text = {
  --   source = "if_many", -- Or "if_many"
  --   prefix = "●", -- Could be '■', '▎', 'x'
  --   spacing = 20,
  -- },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
  severity_sort = true,
  float = {
    source = true, -- Or "if_many"
    border = "single",
  },
})
