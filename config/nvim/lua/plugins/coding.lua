return {
	"AndrewRadev/splitjoin.vim",
	{ "kana/vim-textobj-entire", dependencies = "kana/vim-textobj-user" },
	{ "Julian/vim-textobj-variable-segment", dependencies = "kana/vim-textobj-user" },
	{
		"wellle/targets.vim",
		config = function()
			vim.fn["targets#mappings#extend"]({
				r = { pair = { { o = "[", c = "]" } } },
			})
		end,
	},
}
