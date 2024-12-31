local M = {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  config = function()
    require("conform").setup({
      log_level = vim.log.levels.DEBUG,
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "yapf" },
        -- You can customize some of the format options for the filetype (:help conform.format)
        rust = { "rustfmt", lsp_format = "fallback" },
        markdown = { "prettier", "injected" },
        json = { "jq" },
        yaml = { "prettier" },
        sql = { "sql_formatter" },
        go = { "goimports" },
        -- Conform will run the first available formatter
        sh = { "beautysh", "shfmt", stop_after_first = true, lsp_format = "fallback" },
        toml = { "taplo" },
        nginx = { "ngx" },
        proto = { "buf" },
        cpp = { "clang-format" },
        c = { "clang-format" },
        html = { "prettier" },
        css = { "prettier" },
        ["*"] = { "trim_whitespace", "trim_newlines" },
      },
      formatters = {
        shfmt = {
          args = {
            "-i",
            "2",
            "-sr",
          },
        },
        beautysh = {
          args = {
            "-i",
            "2",
            "-",
          },
        },
        sql_formatter = {
          args = {
            "-c",
            '{"language": "mysql", "dialect":"mysql", "tabWidth":4, "keywordCase":"upper", "useTabs":true, "dataTypeCase":"upper"}',
          },
        },
        ngx = {
          -- download from: https://github.com/slomkowski/nginx-config-formatter
          -- rename nginxfmt.py -> nginxfmt to exec path
          command = "nginxfmt",
          args = { "--pipe" },
        },
        injected = {
          options = {
            ignore_errors = false,
            lang_to_ext = {
              bash = "sh",
              c_sharp = "cs",
              elixir = "exs",
              javascript = "js",
              julia = "jl",
              latex = "tex",
              markdown = "md",
              python = "py",
              ruby = "rb",
              rust = "rs",
              teal = "tl",
              typescript = "ts",
            },
            lang_to_formatters = {
              json = { "jq" },
            },
          },
        },
      },
    })

    -- Can Format a bash code block, using :'<,'>Format sh
    vim.api.nvim_create_user_command("Format", function(cmd)
      local range = nil

      local formatterTable = {
        sh = "beautysh",
      }
      if cmd.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, cmd.line2 - 1, cmd.line2, true)[1]
        range = {
          start = { cmd.line1, 0 },
          ["end"] = { cmd.line2, end_line:len() },
        }
      end

      local formatters = formatterTable[cmd.fargs[1]] or ""
      if formatters ~= "" then
        require("conform").format({
          async = true,
          formatters = { formatters },
          lsp_format = "fallback",
          range = range,
        })
      else
        -- use default
        require("conform").format({ async = true, lsp_format = "fallback", range = range })
      end
    end, { range = true, nargs = "?", bang = true, bar = true })
  end,
  keys = {
    {
      "ff",
      function()
        require("conform").format({ async = true }, function(err)
          if not err then
            local mode = vim.api.nvim_get_mode().mode
            if vim.startswith(string.lower(mode), "v") then
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
            end
          end
        end)
      end,
      desc = "range file format and leave visual mode",
      mode = "x",
    },
    { "ff", "<cmd>Format<CR>", desc = "file format" },
  },
}

return M
