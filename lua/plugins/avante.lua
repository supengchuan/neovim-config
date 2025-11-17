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
      windows = {
        position = "left",
        sidebar_header = {
          align = "right", -- left, center, right for title
        },
      },
      -- 行为配置，确保以 diff 方式生成代码而不是直接修改
      behaviour = {
        auto_apply_diff_after_generation = false, -- 不自动应用生成的 diff
        minimize_diff = true, -- 最小化 diff，只显示必要的更改
        auto_approve_tool_permissions = false, -- 不自动批准工具权限，需要手动确认
        ---@type "popup" | "inline_buttons"
        confirmation_ui_style = "popup",
        -- 添加请求处理相关配置
        cache = false, -- 禁用缓存以确保请求实时处理
        support_native_tools = true, -- 启用原生工具支持
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
      provider = "iflow", -- 使用 iFlow 作为默认提供者
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
          timeout = 30000, -- Timeout in milliseconds
          context_window = 1048576,
          use_ReAct_prompt = true,
          extra_request_body = {
            generationConfig = {
              temperature = 0.75,
            },
          },
        },
      },
    },
  },
}
