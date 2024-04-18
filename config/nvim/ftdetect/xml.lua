vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = {
		"*.cbproj",
		"*.groupproj",
		"*.xaml",
	},
	callback = function()
		vim.cmd.setf("groovy")
	end,
})
