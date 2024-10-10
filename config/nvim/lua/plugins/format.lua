return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				cpp = { "clang-format" },
				javascript = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
			},
		},
		init = function()
			vim.o.formatexpr = "v:lua.require('skippi.lsp').formatexpr()"
		end,
	},
}
