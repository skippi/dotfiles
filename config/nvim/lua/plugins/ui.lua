return {
	{
		"tomasiser/vim-code-dark",
		config = function()
			vim.api.nvim_create_autocmd("ColorScheme", {
				desc = "skippi: add gitsigns color",
				pattern = "*",
				callback = function()
					vim.cmd("hi GitSignsAdd guifg=#5D7D20")
					vim.cmd("hi GitSignsChange guifg=#37718C")
					vim.cmd("hi GitSignsDelete guifg=#95161B")
				end,
			})
			vim.cmd("silent! colorscheme codedark")
		end,
	},
	{ "MTDL9/vim-log-highlighting", ft = "log" },
	{ "pprovost/vim-ps1", ft = "ps1" },
	{
		"MaxMEllon/vim-jsx-pretty",
		ft = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
	},
	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				filetypes = {
					"css",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					html = { mode = "foreground" },
				},
			})
		end,
	},
}
