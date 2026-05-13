local M = {}

local function map(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { buffer = true, desc = desc })
end

local function setup_commands()
  vim.api.nvim_create_user_command("NeoTreeGoRoot", function()
    local current_file = vim.api.nvim_buf_get_name(0)
    local file_dir = vim.fn.fnamemodify(current_file, ":h")
    local project_root = vim.fs.root(file_dir, { "go.work", "go.mod", ".git" })

    if not project_root then
      vim.notify("Failed to find go.work, go.mod, or .git root", vim.log.levels.ERROR)
      return
    end

    vim.cmd("Neotree action=show dir=" .. project_root .. " source=filesystem reveal=true")
    vim.notify("Neo-tree root set to: " .. project_root, vim.log.levels.WARN)
  end, {
    force = true,
    desc = "Set Neo-tree root to Go project root or Git root",
  })

  vim.api.nvim_create_user_command("GoMethodList", function()
    local struct = vim.fn.expand("<cword>")
    local pattern = [[^func\s*\(\s*[\w\*]+\s+\*?]] .. struct .. [[\)\s+]]
    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir = vim.fn.fnamemodify(current_file, ":h")

    require("fzf-lua").grep({
      search = pattern,
      cwd = current_dir,
      no_esc = true,
      winopts = {
        preview = {
          hidden = true,
        },
      },
    })
  end, { desc = "List methods of struct (fzf-lua regex)", force = true })

  vim.api.nvim_create_user_command("Impl", function()
    require("modules.goimpl").open()
  end, { desc = "implement the interface by using impl and fzf-lua", force = true })
end

local function setup_source_keymaps()
  map("<leader>Gr", "<cmd>GoRun<cr>", "go run package")
  map("<leader>Gb", "<cmd>GoBuild<cr>", "go build package")
  map("<leader>Gt", "<cmd>GoTest<cr>", "go test workspace")
  map("<leader>Gf", "<cmd>GoTestFile<cr>", "go test current file")
  map("<leader>Gn", "<cmd>GoTestFunc<cr>", "go test nearest function")
  map("<leader>Gp", "<cmd>GoTestPkg<cr>", "go test current package")
  map("<leader>Gc", "<cmd>GoCoverage -p<cr>", "go test coverage package")
  map("<leader>Gd", "<cmd>GoDebug<cr>", "go debug")
  map("<leader>GD", "<cmd>GoDebug -n<cr>", "go debug nearest test")
  map("<leader>Ga", "<cmd>GoAlt<cr>", "go alternate file")
  map("<leader>Gv", "<cmd>GoAltV<cr>", "go alternate vertical split")
  map("<leader>Gh", "<cmd>GoDoc<cr>", "go doc")
  map("<leader>Gm", "<cmd>GoModTidy<cr>", "go mod tidy")
  map("<leader>Gi", "<cmd>Impl<cr>", "go implement interface picker")
  map("<leader>GI", "<cmd>GoImpl<cr>", "go impl command")
  map("<leader>Ge", "<cmd>GoIfErr<cr>", "go add if err")
  map("<leader>Gs", "<cmd>GoFillStruct<cr>", "go fill struct")
  map("<leader>Gj", "<cmd>GoAddTag json<cr>", "go add json tags")
  map("<leader>GJ", "<cmd>GoRmTag json<cr>", "go remove json tags")
  map("<leader>Gl", "<cmd>GoLint<cr>", "go lint package")
  map("<leader>Gg", "<cmd>GoGenerate<cr>", "go generate package")
end

local function setup_module_keymaps()
  map("<leader>Gm", "<cmd>GoModTidy<cr>", "go mod tidy")
end

local function setup_workspace_keymaps()
  map("<leader>Gw", "<cmd>GoWork sync<cr>", "go work sync")
end

function M.setup(opts)
  opts = opts or {}

  require("filetypes.common").tab_indent(4)
  setup_commands()

  if opts.kind == "gomod" then
    setup_module_keymaps()
  elseif opts.kind == "gowork" then
    setup_workspace_keymaps()
  else
    setup_source_keymaps()
  end

  map("<leader>eg", "<cmd>NeoTreeGoRoot<cr>", "Neo-tree to Go root")
end

return M
