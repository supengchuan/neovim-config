local M = {
  "Civitasv/cmake-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },
  config = function()
    local sep = require("utils").Sep()

    require("cmake-tools").setup({
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" },
      cmake_build_directory = "build" .. sep .. "${variant:buildType}",
      cmake_compile_commands_options = {
        action = "soft_link",
        target = vim.loop.cwd,
      },
      cmake_dap_configuration = {
        name = "CMake target",
        type = "codelldb",
        request = "launch",
        stopOnEntry = false,
        runInTerminal = true,
        console = "integratedTerminal",
      },
      cmake_executor = {
        name = "quickfix",
        opts = {
          show = "only_on_error",
          position = "belowright",
          size = 12,
          auto_close_when_success = true,
        },
      },
      cmake_runner = {
        name = "terminal",
        opts = {
          split_direction = "horizontal",
          split_size = 12,
          focus = false,
          start_insert = false,
        },
      },
    })
  end,
  cmd = {
    "CMakeBuild",
    "CMakeBuildCurrentFile",
    "CMakeClean",
    "CMakeCloseExecutor",
    "CMakeCloseRunner",
    "CMakeDebug",
    "CMakeDebugCurrentFile",
    "CMakeGenerate",
    "CMakeInstall",
    "CMakeLaunchArgs",
    "CMakeOpenCache",
    "CMakeOpenExecutor",
    "CMakeOpenRunner",
    "CMakeQuickBuild",
    "CMakeQuickDebug",
    "CMakeQuickRun",
    "CMakeRun",
    "CMakeRunCurrentFile",
    "CMakeRunTest",
    "CMakeSelectBuildDir",
    "CMakeSelectBuildPreset",
    "CMakeSelectBuildTarget",
    "CMakeSelectBuildType",
    "CMakeSelectConfigurePreset",
    "CMakeSelectKit",
    "CMakeSelectLaunchTarget",
    "CMakeSettings",
    "CMakeStopExecutor",
    "CMakeStopRunner",
    "CMakeTargetSettings",
  },
  event = "VeryLazy",
  keys = {
    { "<leader>bg", "<cmd>CMakeGenerate<cr>", desc = "cmake generate" },
    { "<leader>bb", "<cmd>CMakeBuild<cr>", desc = "cmake build" },
    { "<leader>bB", "<cmd>CMakeSelectBuildType<cr>", desc = "cmake select build type" },
    { "<leader>bc", "<cmd>CMakeClean<cr>", desc = "cmake clean" },
    { "<leader>bd", "<cmd>CMakeDebug<cr>", desc = "cmake debug target" },
    { "<leader>bD", "<cmd>CMakeDebugCurrentFile<cr>", desc = "cmake debug current file target" },
    { "<leader>bf", "<cmd>CMakeBuildCurrentFile<cr>", desc = "cmake build current file target" },
    { "<leader>bk", "<cmd>CMakeSelectKit<cr>", desc = "cmake select kit" },
    { "<leader>bL", "<cmd>CMakeSelectLaunchTarget<cr>", desc = "cmake select launch target" },
    { "<leader>bo", "<cmd>CMakeOpenExecutor<cr>", desc = "cmake open executor" },
    { "<leader>bO", "<cmd>CMakeOpenRunner<cr>", desc = "cmake open runner" },
    { "<leader>bp", "<cmd>CMakeSelectConfigurePreset<cr>", desc = "cmake select configure preset" },
    { "<leader>bP", "<cmd>CMakeSelectBuildPreset<cr>", desc = "cmake select build preset" },
    { "<leader>br", "<cmd>CMakeRun<cr>", desc = "cmake run target" },
    { "<leader>bR", "<cmd>CMakeRunCurrentFile<cr>", desc = "cmake run current file target" },
    { "<leader>bs", "<cmd>CMakeSettings<cr>", desc = "cmake settings" },
    { "<leader>bt", "<cmd>CMakeRunTest<cr>", desc = "cmake run tests" },
    { "<leader>bT", "<cmd>CMakeSelectBuildTarget<cr>", desc = "cmake select build target" },
    {
      "<leader>bx",
      function()
        pcall(vim.cmd, "CMakeStopExecutor")
        pcall(vim.cmd, "CMakeStopRunner")
      end,
      desc = "cmake stop jobs",
    },
  },
}

return M
