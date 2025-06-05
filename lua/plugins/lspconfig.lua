local servers = {
  bashls = {},
  protols = {},
  pyright = {},
  nginx_language_server = {
    capabilities = {
      offsetEncoding = { "utf-16" },
    },
  },
  clangd = {
    filetypes = { "c", "cpp" },
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--fallback-style=llvm",
    },
    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
      clangdFileStatus = true,
    },
  },
  lua_ls = {
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
  },
}

local mason_extra_tools = {
  -- formatter
  "stylua",
  "goimports",
  "shfmt",
  "taplo",
  "prettier",
  "sql-formatter",
  "jq",
  "yapf",

  -- linter
  "shellcheck",

  -- lsp
  "rust-analyzer",
  "gopls",
}

local M = {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- lspkind adds vscode-like pictograms to neovim built-in lsp
    "onsails/lspkind-nvim",
    {
      "williamboman/mason.nvim",
      opts = {
        ui = {
          border = "single",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      },
    },
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    -- for code completion
    "saghen/blink.cmp",
  },

  lazy = false,
  config = function()
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, mason_extra_tools)
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
    --require("mason-lspconfig").setup({
    --  --automatic_enable = {
    --  --  exclude = {
    --  --    "rust_analyzer",
    --  --    "gopls",
    --  --  },
    --  --},
    --  automatic_enable = false,
    --  ensure_installed = {},
    --})

    local capabilities = require("blink-cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    for server_name, server in pairs(servers) do
      server = server or {}
      server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
      require("lspconfig")[server_name].setup(server)
    end
  end,
}
return M
