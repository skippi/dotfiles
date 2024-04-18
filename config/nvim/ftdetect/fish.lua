vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.fish",
	callback = function()
		vim.cmd.setf("fish")
	end,
})
