require("config.options")
require("config.lazy")
require("config.diagnostics")
require("config.autocmds")
require("config.keymaps")
require("config.commands")

require("config.theme").setup()
require("config.theme").apply()

if vim.g.neovide then
  require("config.neovide")
end
