-- markdown
-- install without yarn or npm
local M = {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "npm install && rm package-lock.json && git restore .",
    config = function()
      vim.g.mkdp_open_to_the_world = 1

      local local_ip = "127.0.0.1"
      local on_linux = vim.uv.os_uname().sysname:match("Linux")

      if on_linux then
        local_ip = vim.fn.system("hostname -I | awk '{print $1}'")
      end

      vim.g.mkdp_open_ip = local_ip
      vim.g.mkdp_port = "9414"
      vim.g.mkdp_echo_preview_url = 1
    end,
    keys = {
      { "<leader>p", "<cmd>MarkdownPreviewToggle<CR>", desc = "preview markdown" },
    },
  },
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown" },
    opts = {
      markdown = {
        code_blocks = {
          enable = true,
          style = "simple",
          label_direction = "left",
          min_width = math.floor(vim.o.columns * 0.8) > 120 and 120 or math.floor(vim.o.columns * 0.8),
        },
      },
    },
  },
}

return M
