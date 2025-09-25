return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim", -- for input provider snacks
      "nvim-tree/nvim-web-devicons",
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    opts = {
      -- 行为配置，确保以 diff 方式生成代码而不是直接修改
      behaviour = {
        auto_apply_diff_after_generation = false, -- 不自动应用生成的 diff
        minimize_diff = true, -- 最小化 diff，只显示必要的更改
        auto_approve_tool_permissions = false,
      },
      input = {
        provider = "snacks", -- "native" | "dressing" | "snacks"
        provider_opts = {
          -- Snacks input configuration
          title = "Avante Input",
          icon = " ",
          placeholder = "Enter your API key...",
        },
      },
      auto_suggestions_provider = "deepseek",
      provider = "iflow", -- 使用 iFlow CLI 作为默认提供者
      providers = {
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-reasoner",
          max_tokens = 8192,
        },
        iflow = {
          endpoint = "https://apis.iflow.cn/v1",
          __inherited_from = "openai",
          model = "qwen3-coder",
          api_key_name = "IFLOW_API_KEY", -- iFlow CLI 不需要 API 密钥
        },
      },
      -- ACP 提供者配置 (用于命令行工具集成)
      acp_providers = {
        ["iflow-cli"] = {
          command = "iflow",
          args = { "--yolo=false" }, -- 需要确认操作
          env = {
            NODE_NO_WARNINGS = "1",
            IFLOW_API_KEY = os.getenv("IFLOW_API_KEY"),
          },
        },
      },
    },
  },
}
