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
    },
	go = {
		function ()
			return {
				exe = "goimports",
				stdin = true,
			}
		end
	}
  }
})

