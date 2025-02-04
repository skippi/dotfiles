return {
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("vscode").setup({
				group_overrides = {
					GitSignsAdd = { fg = "#5D7D20" },
					GitSignsChange = { fg = "#37718C" },
					GitSignsDelete = { fg = "#95161B" },
				},
			})
			require("vscode").load()
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
		"j-hui/fidget.nvim",
		event = "LspAttach",
		opts = {},
	},
}
