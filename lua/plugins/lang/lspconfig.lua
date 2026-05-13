local servers = {
  vtsls = {
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    settings = {
      vtsls = { tsserver = { globalPlugins = {} } },
      typescript = {
        inlayHints = {
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
        },
      },
    },
    before_init = function(_, config)
      table.insert(config.settings.vtsls.tsserver.globalPlugins, {
        name = "@vue/typescript-plugin",
        location = vim.fn.expand("$MASON/packages/vue-language-server/node_modules/@vue/language-server"),
        languages = { "vue" },
        configNamespace = "typescript",
        enableForWorkspaceTypeScriptVersions = true,
      })
    end,
    on_attach = function(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  },
  vue_ls = {},
  bashls = {},
  protols = {},
  pyright = {
    settings = {
      python = {
        analysis = {
          autoImportCompletions = true,
          diagnosticMode = "workspace",
          typeCheckingMode = "basic",
          useLibraryCodeForTypes = true,
        },
      },
    },
  },
  ruff = {
    init_options = {
      settings = {
        lineLength = 120,
        lint = {
          select = { "E", "F", "I", "UP", "B" },
        },
      },
    },
  },
  nginx_language_server = {
    capabilities = {
      offsetEncoding = { "utf-16" },
    },
  },
  clangd = {
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
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
  cmake = {
    init_options = {
      buildDirectory = "build/Debug",
    },
  },
  taplo = {},
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
      Lua = {
        diagnostics = {
          globals = {
            "vim",
            "s",
            "c",
            "t",
            "i",
          },
        },
      },
    },
  },
  gopls = {
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    settings = {
      gopls = {
        -- Important: make gopls faster
        directoryFilters = {
          "-.git",
          "-node_modules",
          "-vendor",
          "-bazel-bin",
          "-bazel-out",
        },
        buildFlags = { "-tags", "integration" },
        analyses = {
          nilness = true,
          shadow = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        codelenses = {
          gc_details = true,
          generate = true,
          regenerate_cgo = true,
          run_govulncheck = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
        completeUnimported = true,
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        staticcheck = true,
        usePlaceholders = true,
      },
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
  "ruff",
  "clang-format",
  "cmake-language-server",
  "codelldb",
  "delve",
  "golangci-lint",
  "gofumpt",
  "gomodifytags",
  "gotests",
  "gotestsum",
  "impl",

  -- linter
  "shellcheck",

  -- lsp
  "debugpy",
  "rust-analyzer",
  "vue-language-server",
}

local M = {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- lspkind adds vscode-like pictograms to neovim built-in lsp
    "onsails/lspkind-nvim",
    {
      "mason-org/mason.nvim",
      opts = {
        ui = {
          ---@since 1.0.0
          -- Whether to automatically check for new versions when opening the :Mason window.
          check_outdated_packages_on_open = false,
          border = "single",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      },
    },
    "mason-org/mason-lspconfig.nvim",
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

    local capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    for server_name, server in pairs(servers) do
      server = server or {}
      server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
      vim.lsp.config(server_name, server)
      vim.lsp.enable(server_name)
      -- nvim 0.11+
      --require("lspconfig")[server_name].setup(server)
    end
  end,
}
return M
