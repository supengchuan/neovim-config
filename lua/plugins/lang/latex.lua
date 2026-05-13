-- latex
local M = {
  "lervag/vimtex",
  lazy = false,
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.tex_flavor = "latex"

    vim.g.vimtex_quickfix_mode = 0
    vim.g.vimtex_view_general_viewer = "zathura"
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_compiler_progname = "nvr"
    -- support chinese
    vim.g.Tex_CompileRule_pdf = "xelatex -synctex=1 --interaction=nonstopmode $*"
  end,
  ft = { "tex" },
}

return M
