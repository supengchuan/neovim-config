local M = {
  "saghen/blink.cmp",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "Kaiser-Yang/blink-cmp-avante",
  },
  event = "VeryLazy",
  -- use a release tag to download pre-built binaries
  version = "*",
  -- build = "cargo build --release",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    snippets = { preset = "luasnip" },
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- See the full "keymap" documentation for information on defining your own keymap.
    keymap = {
      preset = "enter",
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        --        "snippet_forward",  -- use <ctrl-k> for snippet_forward instead of <tab>
        "fallback",
      },
    },
    cmdline = {
      enabled = true,
      keymap = {
        preset = "cmdline",
        --["<Tab>"] = {
        --  function(cmp)
        --    if cmp.is_ghost_text_visible() then
        --      return cmp.accept()
        --    end
        --  end,
        --  "select_next",
        --  "fallback",
        --},
        ["<Tab>"] = { "select_and_accept" },
        ["<Left>"] = {},
        ["<Right>"] = {},
      },
      completion = {
        menu = {
          auto_show = true,
        },
      },
    },

    completion = {
      menu = {
        border = "rounded",
        scrollbar = false,
        draw = {
          treesitter = { "lsp" },
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind", gap = 1 },
            { "source_name" },
          },
          components = {
            label_description = {
              width = { max = 10 },
            },
          },
        },
      },
      documentation = {
        auto_show = true,
        window = {
          min_width = 30,
          border = "rounded",
        },
      },
    },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "normal",
      kind_icons = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
      },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { "lsp", "snippets", "buffer", "avante", "path" },
      providers = {
        lsp = {
          fallbacks = { "buffer" }, -- 这里默认的是 buffer, 但在这样会导致lsp有返回时始终命中不了buffer
        },
        path = {
          fallbacks = {}, -- 这里默认的是 buffer, 但在这样会导致lsp有返回时始终命中不了buffer
        },
        avante = {
          module = "blink-cmp-avante",
          name = "Avante",
          opts = {
            -- options for blink-cmp-avante
          },
        },
      },
    },
    fuzzy = {
      sorts = {
        "exact",
        "score",
        "sort_text",
      },
    },
  },
  opts_extend = { "sources.default" },
}

return M
