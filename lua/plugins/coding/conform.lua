local function formatter_names(bufnr)
  local names = {}

  for _, formatter in ipairs(require("conform").list_formatters(bufnr)) do
    if formatter.available then
      names[#names + 1] = formatter.name
    end
  end

  return names
end

local clang_format_style = table.concat({
  "BasedOnStyle: LLVM",
  "IndentWidth: 4",
  "TabWidth: 4",
  "UseTab: Never",
  "ColumnLimit: 120",
}, ", ")

local cpp_header_extensions = {
  h = true,
  hh = true,
  hpp = true,
  hxx = true,
}

local function clang_format_assume_filename(ctx)
  local filename = vim.api.nvim_buf_get_name(ctx.buf)
  local extension = vim.fn.fnamemodify(filename, ":e"):lower()

  if vim.bo[ctx.buf].filetype == "cpp" and cpp_header_extensions[extension] then
    return filename .. ".cpp"
  end

  return "$FILENAME"
end

local function clang_format_base_args(ctx)
  return { "-assume-filename", clang_format_assume_filename(ctx), "--style={" .. clang_format_style .. "}" }
end

local function format_buffer(opts)
  opts = opts or {}
  local bufnr = opts.bufnr or 0
  local conform = require("conform")
  local names = formatter_names(bufnr)

  if opts.notify and #names == 0 then
    local ft = vim.bo[bufnr].filetype
    vim.notify("No available formatter for " .. (ft ~= "" and ft or "current buffer"), vim.log.levels.WARN)
    return
  end

  conform.format({
    async = opts.async ~= false,
    bufnr = bufnr,
    formatters = opts.formatters,
    lsp_format = "fallback",
    range = opts.range,
    timeout_ms = 5000,
  }, function(err, did_edit)
    if opts.leave_visual then
      local mode = vim.api.nvim_get_mode().mode
      if vim.startswith(string.lower(mode), "v") then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
      end
    end

    if not opts.notify then
      return
    end

    vim.schedule(function()
      if err then
        vim.notify("Format failed: " .. tostring(err), vim.log.levels.ERROR)
      elseif did_edit then
        vim.notify("Formatted with " .. table.concat(names, ", "), vim.log.levels.INFO)
      else
        vim.notify("Already formatted", vim.log.levels.INFO)
      end
    end)
  end)
end

local M = {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  config = function()
    local conform = require("conform")

    conform.setup({
      log_level = vim.log.levels.DEBUG,
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_fix", "ruff_organize_imports", "ruff_format", lsp_format = "fallback" },
        -- You can customize some of the format options for the filetype (:help conform.format)
        rust = { "rustfmt", lsp_format = "fallback" },
        markdown = { "prettier", "injected" },
        json = { "jq" },
        yaml = { "prettier" },
        sql = { "sql_formatter" },
        go = { "goimports", "gofumpt" },
        -- Conform will run the first available formatter
        --sh = { "beautysh", "shfmt", stop_after_first = true, lsp_format = "fallback" },
        sh = { "shfmt", stop_after_first = true, lsp_format = "fallback" },
        toml = { "taplo" },
        nginx = { "ngx" },
        proto = { "buf" },
        cpp = { "clang-format" },
        c = { "clang-format" },
        typescript = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        ["*"] = { "trim_whitespace", "trim_newlines" },
        vue = { "prettier" },
      },
      formatters = {
        ["clang-format"] = {
          args = function(_, ctx)
            return clang_format_base_args(ctx)
          end,
          range_args = function(_, ctx)
            local util = require("conform.util")
            local start_offset, end_offset = util.get_offsets_from_range(ctx.buf, ctx.range)
            local length = end_offset - start_offset

            local args = clang_format_base_args(ctx)
            vim.list_extend(args, {
              "--offset",
              tostring(start_offset),
              "--length",
              tostring(length),
            })

            return args
          end,
        },
        shfmt = {
          args = {
            "-i",
            "0",
            "-sr",
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
        format_buffer({
          formatters = { formatters },
          range = range,
        })
      else
        format_buffer({ range = range })
      end
    end, { range = true, nargs = "?", bang = true, bar = true })
  end,
  keys = {
    {
      "<leader>cf",
      function()
        format_buffer({ leave_visual = true, notify = true })
      end,
      desc = "range file format and leave visual mode",
      mode = "x",
    },
    {
      "<leader>cf",
      function()
        format_buffer({ notify = true })
      end,
      desc = "file format",
    },
  },
}

return M
