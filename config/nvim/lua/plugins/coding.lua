return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = "BufReadPost",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag",
			"brianhuster/nvim-treesitter-endwise",
		},
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				ensure_installed = {},
				autotag = { enable = true },
				endwise = { enable = true },
				indent = { enable = true },
				highlight = {
					enable = true,
					disable = function(_, buf)
						if vim.api.nvim_buf_line_count(buf) > 50000 then
							return true
						end
						local max_filesize = 20971520 -- 20 MB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						return ok and stats and stats.size > max_filesize
					end,
				},
				textobjects = {
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]a"] = "@parameter.inner",
							["]m"] = "@function.outer",
							["]g"] = "@comment.outer",
						},
						goto_next_end = {
							["]A"] = "@parameter.inner",
							["]M"] = "@function.outer",
							["]G"] = "@comment.outer",
						},
						goto_previous_start = {
							["[a"] = "@parameter.inner",
							["[m"] = "@function.outer",
							["[g"] = "@comment.outer",
						},
						goto_previous_end = {
							["[A"] = "@parameter.inner",
							["[M"] = "@function.outer",
							["[G"] = "@comment.outer",
						},
					},
				},
			})
		end,
	},
	{
		"andymass/vim-matchup",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			vim.g.matchup_matchparen_enabled = 0
			vim.g.matchup_matchparen_offscreen = {}
			vim.g.matchup_surround_enabled = 1
			vim.g.matchup_transmute_enabled = 0
			require("nvim-treesitter.configs").setup({
				matchup = { enable = true },
			})
		end,
	},
	{
		"tpope/vim-surround",
		keys = {
			{ "ys", mode = { "n", "x" } },
			"cs",
			"ds",
			"yss",
			"yS",
			"ySS",
			{ "S", mode = "x" },
		},
		config = function()
			vim.g.surround_13 = "\n\r\n"
			vim.g.surround_97 = "[\r]"
			vim.g.surround_indent = 1
		end,
	},
	"tpope/vim-unimpaired",
	{
		"echasnovski/mini.ai",
		keys = {
			{ "a", mode = { "x", "o" } },
			{ "i", mode = { "x", "o" } },
		},
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		opts = function()
			local ai = require("mini.ai")
			local util = require("skippi.util")
			return {
				n_lines = 500,
				mappings = {
					goto_left = "m[",
					goto_right = "m]",
				},
				search_method = "cover_or_nearest",
				custom_textobjects = {
					b = { { "%b()", "%b[]", "%b{}" }, "^.%s*().-()%s*.$" },
					B = { { "%b()", "%b[]", "%b{}" }, "^.().*().$" },
					t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tag
					d = { "%f[+-][+-]?()%f[%d]%d+()" }, -- digits
					v = function(ai_type) -- variable segment
						local start_pos, end_pos = unpack(util.find_segment(ai_type))
						return {
							from = { line = start_pos[2], col = start_pos[3] },
							to = {
								line = end_pos[2],
								col = end_pos[3],
							},
						}
					end,
					e = function() -- whole buffer
						return {
							from = { line = 1, col = 1 },
							to = {
								line = vim.fn.line("$"),
								col = math.max(vim.fn.getline("$"):len(), 1),
							},
						}
					end,
					r = { { "%b[]" }, "^.().*().$" },
					u = ai.gen_spec.treesitter({ a = "@assignment.outer", i = "@assignment.inner" }, {}),
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
	{
		"gbprod/substitute.nvim",
		keys = {
			{ "s", "<Cmd>lua require('substitute').operator()<CR>" },
			{ "ss", "<Cmd>lua require('substitute').line()<CR>" },
			{ "S", "<Cmd>lua require('substitute').eol()<CR>" },
			{ "s", "<Cmd>lua require('substitute').visual()<CR>", mode = "x" },
			{ "<Space>s", '"+s', mode = { "n", "x" }, remap = true },
			{ "cx", "<Cmd>lua require('substitute.exchange').operator()<CR>" },
			{ "cxx", "<Cmd>lua require('substitute.exchange').line()<CR>" },
			{ "X", "<Cmd>lua require('substitute.exchange').visual()<CR>", mode = "x" },
		},
		config = function()
			require("substitute").setup({})
		end,
	},
}
