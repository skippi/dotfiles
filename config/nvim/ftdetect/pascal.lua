vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.dfm",
	callback = function()
		vim.cmd.setf("pascal")
	end,
})
