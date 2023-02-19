return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
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
		event = "BufReadPost",
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
						goto_previous_start = {
							["[a"] = "@parameter.inner",
							["[m"] = "@function.outer",
							["[g"] = "@comment.outer",
						},
					},
				},
			})
		end,
	},
	{
		"mfussenegger/nvim-treehopper",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		keys = {
			{ ".", ":lua require('tsht').nodes()<CR>", mode = { "o", "x" }, silent = true },
		},
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
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter" },
		config = function()
			require("treesj").setup({ use_default_keymaps = false, max_join_length = 260 })
			vim.keymap.set("n", "gS", "<Cmd>TSJToggle<CR>")
		end,
	},
	{ "skippi/vim-abolish", cmd = { "Abolish", "S" }, keys = { "cr" } },
	{ "tpope/vim-commentary", keys = { { "gc", mode = { "n", "x" } }, "gcc", "gcgc", "gcu" } },
	{
		"tpope/vim-surround",
		keys = { { "ys", mode = "n", "x" }, "cs", "ds", "yss", "yS", "ySS", { "S", mode = "x" }, { "gS", mode = "x" } },
		config = function()
			vim.g.surround_13 = "\n\r\n"
			vim.g.surround_97 = "[\r]"
			vim.g.surround_indent = 1
		end,
	},
	"tpope/vim-unimpaired",
	{
		"Julian/vim-textobj-variable-segment",
		keys = {
			{ "iv", mode = { "x", "o" } },
			{ "av", mode = { "x", "o" } },
		},
		dependencies = "kana/vim-textobj-user",
	},
	{
		"echasnovski/mini.ai",
		lazy = false,
		keys = {
			{ "a", mode = { "x", "o" } },
			{ "i", mode = { "x", "o" } },
		},
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
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
					e = function()
						return {
							from = { line = 1, col = 1 },
							to = {
								line = vim.fn.line("$"),
								col = math.max(vim.fn.getline("$"):len(), 1),
							},
						}
					end,
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
	{
		"monaqa/dial.nvim",
		keys = {
			{
				"<C-a>",
				function()
					return require("dial.map").inc_normal()
				end,
				expr = true,
			},
			{
				"<C-x>",
				function()
					return require("dial.map").dec_normal()
				end,
				expr = true,
			},
			{
				"<C-a>",
				function()
					require("dial.map").inc_visual()
				end,
				mode = "x",
				expr = true,
			},
			{
				"<C-x>",
				function()
					require("dial.map").dec_visual()
				end,
				mode = "x",
				expr = true,
			},
			{
				"g<C-a>",
				function()
					require("dial.map").inc_gvisual()
				end,
				mode = "x",
				expr = true,
			},
			{
				"g<C-x>",
				function()
					require("dial.map").dec_gvisual()
				end,
				mode = "x",
				expr = true,
			},
		},
		config = function()
			local augend = require("dial.augend")
			local config = require("dial.config")
			config.augends:register_group({
				default = vim.tbl_extend("force", config.augends.group.default, {
					augend.constant.alias.bool,
					augend.integer.alias.binary,
					augend.integer.alias.decimal_int,
					augend.semver.alias.semver,
				}),
			})
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
