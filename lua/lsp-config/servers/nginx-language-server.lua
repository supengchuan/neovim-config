local capabilities = require("lsp-config.common").capabilities
capabilities.offsetEncoding = { "utf-16" }
local opts = {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    local lspComm = require("lsp-config.common")
    lspComm.keyAttach(bufnr)
    lspComm.shwLinDiaAtom(bufnr)
    -- lspComm.hlSymUdrCursor(client, bufnr)
  end,
  handlers = require("lsp-config.common").handlers,
}
return {
  on_setup = function(server)
    server.setup(opts)
  end,
}
