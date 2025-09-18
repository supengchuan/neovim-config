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
      provider = "deepseek",
      providers = {
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-reasoner",
          max_tokens = 8192,
        },
      },
    },
  },
}
