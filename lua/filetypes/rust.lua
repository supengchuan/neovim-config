local M = {}

local function shell_join(parts)
  return table.concat(
    vim.tbl_map(function(part)
      return vim.fn.shellescape(part)
    end, parts),
    " "
  )
end

local function cargo_root()
  return vim.fs.root(0, { "Cargo.toml", ".git" }) or vim.fn.getcwd()
end

local function run_terminal(parts)
  vim.cmd("write")
  vim.cmd("botright split")
  vim.cmd("terminal cd " .. vim.fn.shellescape(cargo_root()) .. " && " .. shell_join(parts))
  vim.cmd("startinsert")
end

local function cargo_command(base)
  return function(opts)
    local parts = { "cargo" }
    vim.list_extend(parts, base)
    vim.list_extend(parts, opts.fargs or {})
    run_terminal(parts)
  end
end

local function rust_lsp(...)
  local args = { ... }
  return function()
    local ok, err = pcall(vim.cmd.RustLsp, args)
    if not ok then
      vim.notify("RustLsp is not ready: " .. tostring(err), vim.log.levels.WARN)
    end
  end
end

local function map(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { buffer = true, desc = desc })
end

local function setup_commands()
  vim.api.nvim_create_user_command("RustCargoBuild", cargo_command({ "build" }), {
    force = true,
    nargs = "*",
    desc = "cargo build",
  })
  vim.api.nvim_create_user_command("RustCargoCheck", cargo_command({ "check" }), {
    force = true,
    nargs = "*",
    desc = "cargo check",
  })
  vim.api.nvim_create_user_command("RustCargoClippy", cargo_command({ "clippy", "--all-targets", "--all-features" }), {
    force = true,
    nargs = "*",
    desc = "cargo clippy",
  })
  vim.api.nvim_create_user_command("RustCargoRun", cargo_command({ "run" }), {
    force = true,
    nargs = "*",
    desc = "cargo run",
  })
  vim.api.nvim_create_user_command("RustCargoTest", cargo_command({ "test" }), {
    force = true,
    nargs = "*",
    desc = "cargo test",
  })
end

function M.setup()
  local common = require("filetypes.common")

  common.indent(4)
  common.text_width(100)
  setup_commands()

  map("<leader>rb", "<cmd>RustCargoBuild<cr>", "cargo build")
  map("<leader>rc", "<cmd>RustCargoCheck<cr>", "cargo check")
  map("<leader>rC", "<cmd>RustCargoClippy<cr>", "cargo clippy")
  map("<leader>rr", "<cmd>RustCargoRun<cr>", "cargo run")
  map("<leader>rt", "<cmd>RustCargoTest<cr>", "cargo test")
  map("<leader>rR", rust_lsp("runnables"), "rust runnables")
  map("<leader>rT", rust_lsp("testables"), "rust testables")
  map("<leader>rd", rust_lsp("debug"), "rust debug at cursor")
  map("<leader>rD", rust_lsp("debuggables"), "rust debuggables")
  map("<leader>ra", rust_lsp("codeAction"), "rust code action")
  map("<leader>rh", rust_lsp("hover", "actions"), "rust hover actions")
  map("<leader>re", rust_lsp("explainError", "current"), "rust explain error")
  map("<leader>rE", rust_lsp("renderDiagnostic", "current"), "rust render diagnostic")
  map("<leader>rm", rust_lsp("expandMacro"), "rust expand macro")
  map("<leader>rM", rust_lsp("rebuildProcMacros"), "rust rebuild proc macros")
  map("<leader>ro", rust_lsp("openDocs"), "rust open docs")
  map("<leader>rp", rust_lsp("parentModule"), "rust parent module")
  map("<leader>rj", rust_lsp("joinLines"), "rust join lines")
  map("<leader>rl", rust_lsp("reloadWorkspace"), "rust reload workspace")
  map("<leader>rs", rust_lsp("workspaceSymbol", "allSymbols"), "rust workspace symbols")
  map("<leader>rS", rust_lsp("syntaxTree"), "rust syntax tree")
end

return M
