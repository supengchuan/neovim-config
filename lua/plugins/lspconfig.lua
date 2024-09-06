local servers = {}

servers.clangd = function()
  local capabilities = require("lsp-config.common").capabilities
  capabilities.offsetEncoding = { "utf-16" }
  local opts = {
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    capabilities = capabilities,
    on_attach = function(client, bufnr)
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
    on_attach = function(client, bufnr)
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
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  local opts = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
    capabilities = require("lsp-config.common").capabilities,
    on_attach = function(client, bufnr)
      local lspComm = require("lsp-config.common")
      lspComm.keyAttach(bufnr)
      lspComm.disableFormat(client)
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

servers.pyright = function()
  local opts = {
    capabilities = require("lsp-config.common").capabilities,
    on_attach = function(client, bufnr)
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

servers.sqlls = function()
  local opts = {}

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

servers.bufls = function()
  local opts = {
    capabilities = require("lsp-config.common").capabilities,
    on_attach = function(client, bufnr)
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
  config = function()
    -- Setup lspconfig.
    local status, lspconfig = pcall(require, "lspconfig")
    if not status then
      vim.notify("没有找到 lspconfig")
      return
    end

    for name, config in pairs(servers) do
      if config ~= nil and type(config) == "table" then
        -- 自定义初始化配置文件必须实现on_setup 方法
        config.on_setup(lspconfig[name])
      else
        -- 使用默认参数
        lspconfig[name].setup({})
      end
    end
  end,
}
return M
