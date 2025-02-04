return {
	{ "jghauser/mkdir.nvim", event = "BufWritePre" },
	{ "nvim-lua/plenary.nvim", lazy = true },
	{
		"rmagatti/auto-session",
		lazy = false,
		opts = {
			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		},
	},
	{ "tpope/vim-repeat", event = "VeryLazy" },
}
