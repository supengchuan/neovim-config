local function rustacean_config()
  return {
    tools = {
      float_win_config = {
        auto_focus = true,
        border = {
          { "╭", "FloatBorder" },
          { "─", "FloatBorder" },
          { "╮", "FloatBorder" },
          { "│", "FloatBorder" },
          { "╯", "FloatBorder" },
          { "─", "FloatBorder" },
          { "╰", "FloatBorder" },
          { "│", "FloatBorder" },
        },
      },
    },
    server = {
      standalone = false,
      default_settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            allTargets = true,
            buildScripts = {
              enable = true,
            },
          },
          check = {
            command = "clippy",
            extraArgs = { "--all-targets", "--all-features" },
          },
          completion = {
            snippets = "all",
            fullFunctionSignatures = {
              enable = true,
            },
            derive = {
              enable = true,
            },
          },
          diagnostics = {
            enable = true,
          },
          imports = {
            granularity = {
              group = "module",
            },
            prefix = "crate",
          },
          inlayHints = {
            bindingModeHints = {
              enable = true,
            },
            closureCaptureHints = {
              enable = true,
            },
            closureReturnTypeHints = {
              enable = "always",
            },
            lifetimeElisionHints = {
              enable = "skip_trivial",
              useParameterNames = true,
            },
          },
          lens = {
            enable = true,
            implementations = {
              enable = true,
            },
            references = {
              adt = {
                enable = true,
              },
              enumVariant = {
                enable = true,
              },
              method = {
                enable = true,
              },
              trait = {
                enable = true,
              },
            },
          },
          procMacro = {
            enable = true,
          },
        },
      },
    },
  }
end

return {
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    init = function()
      vim.g.rustaceanvim = rustacean_config()
    end,
  },
  {
    "saecki/crates.nvim",
    tag = "stable",
    ft = { "toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      completion = {
        blink = {
          use_custom_kind = true,
        },
        crates = {
          enabled = true,
        },
      },
      popup = {
        border = "single",
      },
    },
  },
}
