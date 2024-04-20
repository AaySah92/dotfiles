require('lsp-zero')
require('lspconfig').lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = {'vim'}
	      		}
	    	}
  	}
})
require('lspconfig').gopls.setup({})
require('lspconfig').bashls.setup({})
