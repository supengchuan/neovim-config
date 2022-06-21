require("formatter").setup(
{
  logging=false,
  filetype = {
    rust = {
      function()
	    return {
		  exe = "rustfmt",
	  	  args = {"--emit=stdout"},
		    stdin = true
		  }
	  end
    }
  }
})

-- auto  format  when saved
vim.cmd [[
augroup FormatAutogroup
autocmd!
autocmd BufWritePost *.js,*.jsx,*.ts,*.tsx,*.rs,*.lua FormatWrite
augroup END
]]
