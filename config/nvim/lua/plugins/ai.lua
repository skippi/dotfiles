return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{ "<space>i", ":CodeCompanionActions<cr>", mode = { "n", "x" }, silent = true },
		},
		opts = {
			adapters = {
				llama3 = function()
					return require("codecompanion.adapters").extend("ollama", {
						name = "llama3",
						schema = { model = { default = "llama3:8b" } },
					})
				end,
				llama32 = function()
					return require("codecompanion.adapters").extend("ollama", {
						name = "llama32",
						schema = { model = { default = "llama3.2:latest" } },
					})
				end,
				yicoder = function()
					return require("codecompanion.adapters").extend("ollama", {
						name = "yicoder",
						schema = { model = { default = "yi-coder:9b" } },
					})
				end,
			},
			strategies = {
				chat = {
					adapter = "llama3",
				},
				inline = {
					adapter = "llama3",
				},
				agent = {
					adapter = "llama3",
				},
			},
		},
	},
}
