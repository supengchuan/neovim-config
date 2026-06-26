local python_root_markers = {
  "pyrightconfig.json",
  "pyproject.toml",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "Pipfile",
  "uv.lock",
  "poetry.lock",
  ".venv",
  ".git",
}

local python_venv_dirs = { ".venv", "venv", ".env" }
local python_extra_dirs = { "src", "tests" }
local python_analysis_exclude = {
  "**/.git",
  "**/.venv",
  "**/venv",
  "**/.env",
  "**/__pycache__",
  "**/.pytest_cache",
  "**/.ruff_cache",
  "**/*.egg-info",
}

local clangd_root_markers = {
  "compile_commands.json",
  "compile_flags.txt",
  ".clangd",
  "CMakeLists.txt",
  ".git",
}

local clangd_query_drivers = table.concat({
  "/usr/bin/clang",
  "/usr/bin/clang++",
  "/usr/bin/gcc",
  "/usr/bin/g++",
  "/usr/local/bin/clang",
  "/usr/local/bin/clang++",
  "/usr/local/bin/gcc-*",
  "/usr/local/bin/g++-*",
  "/opt/homebrew/bin/clang",
  "/opt/homebrew/bin/clang++",
  "/opt/homebrew/bin/gcc-*",
  "/opt/homebrew/bin/g++-*",
  "/opt/homebrew/opt/llvm/bin/clang",
  "/opt/homebrew/opt/llvm/bin/clang++",
}, ",")

local clangd_fallback_include_dirs = { ".", "include", "src" }

local function append_unique(target, values)
  local result = {}
  local seen = {}

  for _, value in ipairs(target or {}) do
    if value ~= nil and value ~= "" and not seen[value] then
      seen[value] = true
      table.insert(result, value)
    end
  end

  for _, value in ipairs(values or {}) do
    if value ~= nil and value ~= "" and not seen[value] then
      seen[value] = true
      table.insert(result, value)
    end
  end

  return result
end

local function is_dir(path)
  local stat = path and vim.uv.fs_stat(path)
  return stat and stat.type == "directory"
end

local function find_project_python(root_dir)
  if not root_dir or root_dir == "" then
    return nil
  end

  for _, venv_name in ipairs(python_venv_dirs) do
    local venv_dir = vim.fs.joinpath(root_dir, venv_name)
    for _, executable in ipairs({ "bin/python", "bin/python3", "Scripts/python.exe" }) do
      local python = vim.fs.joinpath(venv_dir, executable)
      if vim.fn.executable(python) == 1 then
        return python, venv_dir
      end
    end
  end

  return nil
end

local function find_python_extra_paths(root_dir)
  local paths = {}
  if not root_dir or root_dir == "" then
    return paths
  end

  for _, dir_name in ipairs(python_extra_dirs) do
    local path = vim.fs.joinpath(root_dir, dir_name)
    if is_dir(path) then
      table.insert(paths, path)
    end
  end

  return paths
end

local function root_uri_to_path(root_uri)
  if type(root_uri) == "string" then
    local ok, path = pcall(vim.uri_to_fname, root_uri)
    return ok and path or nil
  end

  return nil
end

local function configure_pyright_environment(params, config)
  local root_dir = config.root_dir
    or root_uri_to_path(params.rootUri)
    or vim.fs.root(0, python_root_markers)
    or vim.fn.getcwd()
  local python, venv_dir = find_project_python(root_dir)

  config.settings = config.settings or {}
  config.settings.python = config.settings.python or {}
  config.settings.python.analysis = config.settings.python.analysis or {}

  local analysis = config.settings.python.analysis
  analysis.extraPaths = append_unique(analysis.extraPaths, find_python_extra_paths(root_dir))
  analysis.exclude = append_unique(analysis.exclude, python_analysis_exclude)

  if python and venv_dir then
    config.settings.python.pythonPath = python
    config.settings.python.venv = vim.fn.fnamemodify(venv_dir, ":t")
    config.settings.python.venvPath = vim.fn.fnamemodify(venv_dir, ":h")
  end
end

local function find_clangd_fallback_flags(root_dir)
  local flags = {}
  if not root_dir or root_dir == "" then
    return flags
  end

  for _, dir_name in ipairs(clangd_fallback_include_dirs) do
    local path = dir_name == "." and root_dir or vim.fs.joinpath(root_dir, dir_name)
    if is_dir(path) then
      table.insert(flags, "-I" .. path)
    end
  end

  return flags
end

local function configure_clangd_environment(params, config)
  local root_dir = config.root_dir
    or root_uri_to_path(params.rootUri)
    or vim.fs.root(0, clangd_root_markers)
    or vim.fn.getcwd()

  config.init_options = config.init_options or {}
  config.init_options.fallbackFlags = append_unique(
    config.init_options.fallbackFlags,
    find_clangd_fallback_flags(root_dir)
  )
end

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
    root_markers = python_root_markers,
    before_init = configure_pyright_environment,
    capabilities = {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      },
    },
    settings = {
      python = {
        analysis = {
          autoImportCompletions = true,
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          diagnosticSeverityOverrides = {
            reportArgumentType = "warning",
            reportCallIssue = "warning",
            reportPrivateImportUsage = "none",
          },
          indexing = true,
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
    root_markers = clangd_root_markers,
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    before_init = configure_clangd_environment,
    capabilities = {
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = false,
          },
        },
      },
    },
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--query-driver=" .. clangd_query_drivers,
      "--header-insertion=never",
      "--completion-style=detailed",
      "--fallback-style=llvm",
    },
    init_options = {
      usePlaceholders = false,
      completeUnimported = false,
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
    require("mason-tool-installer").setup({
      ensure_installed = ensure_installed,
      run_on_start = true,
    })
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
    capabilities.workspace = capabilities.workspace or {}
    capabilities.workspace.didChangeWatchedFiles = capabilities.workspace.didChangeWatchedFiles or {}
    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

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
