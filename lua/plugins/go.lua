local function setEnvFromFile()
  -- auto load .env file in project dir
  -- if cannot find .env file, donot call load_env()
  local sep = require("utils").Sep()
  local rootDir = vim.fs.root(0, "go.mod")
  if rootDir == nil then
    return
  end
  local envFile = vim.fs.root(0, "go.mod") .. sep .. ".env"
  if vim.fn.filereadable(envFile) ~= 0 then
    require("go.env").load_env(envFile, true)
  end
end

local M = {
  "ray-x/go.nvim",
  dependencies = { -- optional packages
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

    -- set config
    require("go").setup({
      tag_transform = "camelcase",
      icons = false,
      lsp_cfg = {
        capabilities = capabilities,
        settings = {
          gopls = {
            hints = {
              parameterNames = true,
            },
          },
        },
      },
      lsp_codelens = false,
      lsp_inlay_hints = {
        enable = false,
      },
      lsp_keymaps = false,
      comment_placeholder = "  ",
      diagnostic = false, -- set diagnostic to false to disable diagnostic
    })
    -- auto load .env file in project dir
    setEnvFromFile()
  end,

  --event = { "CmdlineEnter" },
  ft = { "go", "gomod" },
  build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
}

return M
