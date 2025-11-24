vim.lsp.config("*", {
	root_markers = { ".git" }
})

vim.lsp.enable("yaml")

vim.diagnostic.config({
	virtual_text = true
})
