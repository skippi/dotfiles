return {
	{ "jghauser/mkdir.nvim", event = "BufWritePre" },
	{ "nvim-lua/plenary.nvim", lazy = true },
	{ "tpope/vim-obsession", event = "VeryLazy" },
	{ "tpope/vim-repeat", event = "VeryLazy" },
	{
		"williamboman/mason.nvim",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()
		end,
	},
}
