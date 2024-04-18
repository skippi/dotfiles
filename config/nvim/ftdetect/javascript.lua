vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.sj",
	callback = function()
		vim.cmd.setf("javascript")
	end,
})
