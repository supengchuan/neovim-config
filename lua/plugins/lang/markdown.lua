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

      local config_dir = vim.fn.stdpath("config")
      vim.g.mkdp_markdown_css = config_dir .. "/markdown.css"
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    ft = { "markdown", "Avante", "codecompanion" },
    cmd = { "RenderMarkdown" },
    opts = {
      enabled = true,
      file_types = { "markdown", "Avante", "codecompanion" },
      render_modes = { "n", "i", "c", "t" },
      anti_conceal = {
        enabled = false,
      },
      heading = {
        position = "inline",
      },
      pipe_table = {
        preset = "round",
        border_virtual = false,
      },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)
    end,
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", ft = "markdown", desc = "toggle markdown render" },
      { "<leader>mp", "<cmd>RenderMarkdown preview<cr>", ft = "markdown", desc = "preview rendered markdown" },
      { "<leader>mP", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "toggle browser markdown preview" },
    },
  },
}

return M
