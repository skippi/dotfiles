return {
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require('vscode').setup({
				group_overrides = {
					GitSignsAdd = { fg="#5D7D20" },
					GitSignsChange = { fg="#37718C" },
					GitSignsDelete = { fg="#95161B" },
				}
			})
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
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		config = function()
			require("fidget").setup({})
		end,
	},
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		keys = {
			{ "<Space>t", "<Cmd>TroubleToggle<CR>" },
		},
		config = function()
			require("trouble").setup({ icons = false })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPost",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesitter-context").setup({ enable = vim.o.cursorline })
			local callback = function()
				if vim.wo.cursorline then
					vim.cmd("TSContextEnable")
				else
					vim.cmd("TSContextDisable")
				end
			end
			vim.api.nvim_create_autocmd("OptionSet", {
				pattern = "cursorline",
				callback = callback,
			})
			vim.api.nvim_create_autocmd("WinEnter", {
				callback = callback,
			})
		end,
	},
}
