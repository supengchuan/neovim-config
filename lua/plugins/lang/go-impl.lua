local M = {
  "fang2hou/go-impl.nvim",
  ft = "go",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "ibhagwan/fzf-lua",
  },
  opts = {},
  keys = {
    {
      "<leader>cg",
      function()
        require("modules.goimpl").open()
      end,
      mode = { "n" },
      desc = "generate Go interface implementation",
    },
  },
}
return M
