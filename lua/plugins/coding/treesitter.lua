local M = {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- put your config here
      require("nvim-treesitter").install({
        "rust",
        "javascript",
        "c",
        "cpp",
        "cmake",
        "lua",
        "vim",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "toml",
        "vimdoc",
        "yaml",
        "bash",
        "sql",
        "proto",
        "css",
        "markdown",
        "json",
        "python",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true

      -- Or, disable per filetype (add as you like)
      -- vim.g.no_python_maps = true
      -- vim.g.no_ruby_maps = true
      -- vim.g.no_rust_maps = true
      -- vim.g.no_go_maps = true
    end,
    config = function() end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    config = function()
      require("treesitter-context").setup({
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        multiwindow = true, -- Keep sticky context state independent per split.
        max_lines = 3, -- Bound the floating context so it cannot cover too much of a split.
        min_window_height = 20, -- Avoid showing context in short splits.
        line_numbers = false,
        multiline_threshold = 4, -- Keep long function/class headers compact.
        trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = "topline", -- Calculate context from each window's visible top line.
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      })
    end,
    keys = {
      --{
      --  "[c",
      --  function()
      --    require("treesitter-context").go_to_context(vim.v.count1)
      --  end,
      --  desc = "jump to context(upwards)",
      --},
    },
  },
}
return M
