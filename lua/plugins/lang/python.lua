local function get_debugpy_python()
  local sep = require("utils").Sep()
  local package_path = vim.fn.stdpath("data") .. sep .. "mason" .. sep .. "packages" .. sep .. "debugpy"
  local python = package_path .. sep .. "venv" .. sep .. "bin" .. sep .. "python"

  if require("utils").IsWindows() then
    python = package_path .. sep .. "venv" .. sep .. "Scripts" .. sep .. "python.exe"
  end

  if vim.fn.executable(python) == 1 then
    return python
  end

  return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or "python"
end

local function find_python_command(root)
  local prune = [[\( -path '*/.git' -o -path '*/site-packages' -o -path '*/__pycache__' \) -prune]]
  local python = [[\( -type f -o -type l \) \( -path '*/bin/python' -o -path '*/bin/python3' \) -print]]

  return string.format("[ -d %s ] && find %s %s -o %s 2>/dev/null", root, root, prune, python)
end

return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-python").setup(get_debugpy_python())
      require("dap-python").test_runner = "pytest"
    end,
    keys = {
      {
        "<leader>pt",
        function()
          require("dap-python").test_method()
        end,
        ft = "python",
        desc = "debug nearest python test",
      },
      {
        "<leader>pT",
        function()
          require("dap-python").test_class()
        end,
        ft = "python",
        desc = "debug python test class",
      },
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    ft = "python",
    dependencies = {
      "neovim/nvim-lspconfig",
      "ibhagwan/fzf-lua",
    },
    opts = {
      options = {
        enable_default_searches = false,
        fd_binary_name = "find",
        notify_user_on_venv_activation = true,
        picker = "fzf-lua",
      },
      search = {
        project = {
          command = find_python_command([["$CWD"]]),
        },
        workspace = {
          command = find_python_command([["$WORKSPACE_PATH"]]),
        },
        file_dir = {
          command = find_python_command([["$FILE_DIR"]]),
        },
        poetry_cache = {
          command = find_python_command([[~/Library/Caches/pypoetry/virtualenvs]]),
        },
        poetry_cache_unix = {
          command = find_python_command([[~/.cache/pypoetry/virtualenvs]]),
        },
        virtualenvs = {
          command = find_python_command([[~/.virtualenvs]]),
        },
        pipenv = {
          command = find_python_command([[~/.local/share/virtualenvs]]),
        },
        conda = {
          command = find_python_command([[~/.conda/envs]]),
        },
        miniconda = {
          command = find_python_command([[~/miniconda3/envs]]),
        },
        anaconda = {
          command = find_python_command([[~/anaconda3/envs]]),
        },
      },
    },
    keys = {
      {
        "<leader>pv",
        "<cmd>VenvSelect<cr>",
        ft = "python",
        desc = "select python virtualenv",
      },
      {
        "<leader>pc",
        function()
          require("venv-selector.cached_venv").retrieve(0, function(activated)
            if not activated then
              vim.notify("No cached python virtualenv for this project", vim.log.levels.INFO)
            end
          end)
        end,
        ft = "python",
        desc = "reuse cached python virtualenv",
      },
    },
  },
}
