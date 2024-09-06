local M = {
  "stevearc/conform.nvim",
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
        sh = { "shfmt" },
        toml = { "taplo" },
        nginx = { "ngx" },
        proto = { "buf" },
        cpp = { "clang-format" },
        c = { "clang-format" },
        ["*"] = { "trim_whitespace", "trim_newlines" },
      },

      formatters = {
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
            ignore_errors = true,
          },
        },
      },
    })

    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format({ async = true, lsp_format = "fallback", range = range })
    end, { range = true })
  end,
}

return M
