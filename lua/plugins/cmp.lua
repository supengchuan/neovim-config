local M = {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", --nvim-cmp source for neovim's built-in language server client.
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "onsails/lspkind-nvim",
  },
  event = "VeryLazy",
  config = function()
    local cmp = require("cmp")

    -- Setup nvim-cmp.
    cmp.setup({
      view = {
        docs = {
          auto_open = true,
        },
      },
      formatting = {
        expandable_indicator = true,
        fields = { "abbr", "kind", "menu" }, -- this is default
        format = function(entry, vim_item)
          local lspkind = require("lspkind")
          -- From lspkind
          return lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = {
              -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
              -- can also be a function to dynamically calculate max width such as
              -- menu = function() return math.floor(0.45 * vim.o.columns) end,
              menu = 50, -- leading text (labelDetails)
              abbr = 50, --actual suggestion item
            },
            ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            show_labelDetails = true, -- show labelDetails in menu. Disabled by default
            before = function(_, item)
              local m = item.menu and item.menu or ""
              if #m > 30 then
                item.menu = string.sub(m, 1, 35) .. "..." .. string.sub(m, -12)
              end
              return item
            end,
          })(entry, vim_item)
        end,
      },

      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      window = {
        completion = cmp.config.window.bordered({
          border = "rounded",
          scrollbar = false,
        }),
        documentation = cmp.config.window.bordered({
          border = "rounded",
        }),
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<tab>"] = cmp.config.disable,
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),

      sources = cmp.config.sources({
        { name = "lazydev", group_index = 0 },
        { name = "nvim_lsp", group_index = 1 },
        { name = "luasnip", group_index = 1 }, -- For luasnip users.
        { name = "nvim_lsp_signature_help", group_index = 1 },
        {
          name = "buffer",
          option = {
            get_bufnrs = function()
              local buf = vim.api.nvim_get_current_buf()
              local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
              if byte_size > 1024 * 1024 then -- 1 Megabyte max
                return {}
              end
              return { buf }
            end,
          },
          group_index = 2,
        },
        { name = "path", group_index = 2 },
      }),

      experimental = {
        -- Let's play with this for a day or two
        ghost_text = false,
      },
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype("gitcommit", {
      sources = cmp.config.sources({
        { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
      }, {
        { name = "buffer" },
      }),
    })

    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        {
          name = "buffer",
          option = {
            get_bufnrs = function()
              local buf = vim.api.nvim_get_current_buf()
              local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
              if byte_size > 1024 * 1024 then -- 1 Megabyte max
                return {}
              end
              return { buf }
            end,
          },
        },
      },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        -- https://github.com/hrsh7th/cmp-cmdline/issues/24
        -- https://github.com/hrsh7th/nvim-cmp/issues/821
        -- Solve the problem that typing :! in command mode takes too long time for wait  ENV:WSL2
        -- { name = 'cmdline', keyword_pattern = [[\!\@<!\w*]] }
        { name = "cmdline" },
      }),
    })

    -- If you want insert `(` after select function or method item
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    -- create a command to toggle auto open documentation for cmp
    vim.api.nvim_create_user_command("CmpToggleDoc", function()
      if cmp.visible_docs() then
        cmp.close_docs()
      else
        cmp.open_docs()
      end
    end, {})
  end,
}

return M
