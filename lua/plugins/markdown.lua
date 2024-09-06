-- markdown
-- install without yarn or npm
local M = {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = "cd app && yarn install",
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
}

return M
