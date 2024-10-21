return {
	{
		"olimorris/codecompanion.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{ "<space>i", ":CodeCompanionActions<cr>", mode = { "n", "x" }, silent = true },
			{ "<space>I", ":CodeCompanion<cr>", mode = { "n", "x" }, silent = true },
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
		config = function(_, opts)
			local util = require("skippi.util")
			require("codecompanion").setup(opts)
			util.create_command_alias("cod[ecompanionchat]", "CodeCompanionChat")
			local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})
			vim.api.nvim_create_autocmd({ "User" }, {
				pattern = "CodeCompanionInlineFinished",
				group = group,
				callback = function(request)
					local diffs = require("skippi.buffers").find_diff_chunks()
					vim.print(diffs)
					for _, diff in ipairs(diffs) do
						util.format({ range = {
							start = { diff[1], 0 },
							["end"] = { diff[2], 0 },
						} })
					end
				end,
			})
		end,
	},
}
