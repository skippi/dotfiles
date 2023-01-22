return {
	{
		"windwp/nvim-autopairs",
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			require("nvim-autopairs").setup({})
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {},
				autotag = { enable = true },
				highlight = {
					enable = true,
					disable = function(_, buf)
						local max_filesize = 20971520 -- 20 MB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
						return false
					end,
				},
				textobjects = {
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
				},
			})
		end,
	},
	{
		"mfussenegger/nvim-treehopper",
		keys = {
			{ ".", ":<C-u>lua require('tsht').nodes()<CR>", mode = "o", silent = true },
			{ ".", ":lua require('tsht').nodes()<CR>", mode = "x", silent = true },
		},
	},
	"AndrewRadev/splitjoin.vim",
	{ "kana/vim-textobj-entire", dependencies = "kana/vim-textobj-user" },
	{ "Julian/vim-textobj-variable-segment", dependencies = "kana/vim-textobj-user" },
	{
		"echasnovski/mini.ai",
		keys = {
			{ "a", mode = { "x", "o" } },
			{ "i", mode = { "x", "o" } },
		},
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				init = function()
					-- no need to load the plugin, since we only need its queries
					require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
				end,
			},
		},
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				mappings = {
					goto_left = "m[",
					goto_right = "m]",
				},
				search_method = "cover_or_nearest",
				custom_textobjects = {
					["b"] = { { "%b()", "%b[]", "%b{}" }, "^.%s*().-()%s*.$" },
					["B"] = { { "%b()", "%b[]", "%b{}" }, "^.().*().$" },
					r = { { "%b[]" }, "^.().*().$" },
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
					o = ai.gen_spec.treesitter({
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}, {}),
				},
			}
		end,
		config = function(_, opts)
			require("mini.ai").setup(opts)
		end,
	},
}
