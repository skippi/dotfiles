vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.Jenkinsfile",
	callback = function()
		vim.cmd.setf("groovy")
	end,
})
