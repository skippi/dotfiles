return {
	{ "stevearc/oil.nvim", cmd = "Oil", opts = { default_file_explorer = false } },
	{
		"tpope/vim-vinegar",
		keys = {
			{
				"-",
				function()
					if vim.v.count == 0 then
						return "<Plug>VinegarUp"
					end
					return "<Cmd>Browse<CR>"
				end,
				expr = true,
				desc = "open current file parent directory",
			},
		},
		ft = "netrw",
	},
}
