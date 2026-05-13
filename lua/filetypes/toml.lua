local M = {}

local function is_cargo_toml()
  return vim.fn.expand("%:t") == "Cargo.toml"
end

local function crates_call(method)
  return function()
    if not is_cargo_toml() then
      vim.notify("crates.nvim keymaps are only active for Cargo.toml", vim.log.levels.INFO)
      return
    end

    local ok, crates = pcall(require, "crates")
    if not ok then
      vim.notify("crates.nvim is not loaded", vim.log.levels.WARN)
      return
    end

    crates[method]()
  end
end

local function map(lhs, method, desc)
  vim.keymap.set("n", lhs, crates_call(method), { buffer = true, desc = desc })
end

function M.setup()
  require("filetypes.common").indent(2)

  if not is_cargo_toml() then
    return
  end

  map("<leader>rv", "show_versions_popup", "cargo crate versions")
  map("<leader>rf", "show_features_popup", "cargo crate features")
  map("<leader>rP", "show_dependencies_popup", "cargo crate dependencies")
  map("<leader>ru", "update_crate", "cargo update crate")
  map("<leader>rU", "upgrade_crate", "cargo upgrade crate")
  map("<leader>ra", "update_all_crates", "cargo update all crates")
  map("<leader>rA", "upgrade_all_crates", "cargo upgrade all crates")
  map("<leader>rH", "open_homepage", "cargo crate homepage")
  map("<leader>rO", "open_repository", "cargo crate repository")
  map("<leader>rW", "open_crates_io", "cargo crate crates.io")
end

return M
