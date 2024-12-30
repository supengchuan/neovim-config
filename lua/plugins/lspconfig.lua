local servers = {}

servers.clangd = function()
  local capabilities = require("lsp-config.common").capabilities
  capabilities.offsetEncoding = { "utf-16" }
  local opts = {
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    capabilities = capabilities,
    on_attach = function(_, bufnr)
      local lspComm = require("lsp-config.common")
      lspComm.keyAttach(bufnr)
      lspComm.shwLinDiaAtom(bufnr)
      -- lspComm.hlSymUdrCursor(client, bufnr)
    end,
    handlers = require("lsp-config.common").handlers,
  }
  return {
    on_setup = function(server)
      server.setup(opts)
    end,
  }
end

servers.nginx_language_server = function()
  local capabilities = require("lsp-config.common").capabilities
  capabilities.offsetEncoding = { "utf-16" }
  local opts = {
    capabilities = capabilities,
    on_attach = function(_, bufnr)
      local lspComm = require("lsp-config.common")
      lspComm.keyAttach(bufnr)
      lspComm.shwLinDiaAtom(bufnr)
      -- lspComm.hlSymUdrCursor(client, bufnr)
    end,
    handlers = require("lsp-config.common").handlers,
  }
  return {
    on_setup = function(server)
      server.setup(opts)
    end,
  }
end

servers.lua_ls = function()
  return {
    on_setup = function(server)
      server.setup({
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
            return
          end

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                -- Depending on the usage, you might want to add additional paths here.
                -- "${3rd}/luv/library"
                -- "${3rd}/busted/library",
              },
              -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
              -- library = vim.api.nvim_get_runtime_file("", true)
            },
          })
        end,
        settings = {
          Lua = {},
        },
      })
    end,
  }
end

servers.pyright = function()
  local opts = {
    capabilities = require("lsp-config.common").capabilities,
    on_attach = function(_, bufnr)
      local lspComm = require("lsp-config.common")
      lspComm.keyAttach(bufnr)
      lspComm.shwLinDiaAtom(bufnr)
      -- lspComm.hlSymUdrCursor(client, bufnr)
    end,
    handlers = require("lsp-config.common").handlers,
  }

  return {
    on_setup = function(server)
      server.setup(opts)
    end,
  }
end

servers.bashls = function()
  local opts = {}

  return {
    on_setup = function(server)
      server.setup(opts)
    end,
  }
end

servers.buf_ls = function()
  local opts = {
    capabilities = require("lsp-config.common").capabilities,
    on_attach = function(_, bufnr)
      local lspComm = require("lsp-config.common")
      lspComm.keyAttach(bufnr)
      lspComm.shwLinDiaAtom(bufnr)
      -- lspComm.hlSymUdrCursor(client, bufnr)
    end,
    handlers = require("lsp-config.common").handlers,
  }

  return {
    on_setup = function(server)
      server.setup(opts)
    end,
  }
end

local M = {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- lspkind adds vscode-like pictograms to neovim built-in lsp
    "onsails/lspkind-nvim",
  },
  event = "VeryLazy",
  config = function()
    -- Setup lspconfig.
    local status, lspconfig = pcall(require, "lspconfig")
    if not status then
      vim.notify("没有找到 lspconfig")
      return
    end

    for name, config in pairs(servers) do
      if config ~= nil and type(config) == "function" then
        -- 自定义初始化配置文件必须实现on_setup 方法
        config().on_setup(lspconfig[name])
      else
        -- 使用默认参数
        lspconfig[name].setup({})
      end
    end
  end,
  keys = {
    { "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "show lsp hint" },
    { "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "rename token" },
  },
}
return M
