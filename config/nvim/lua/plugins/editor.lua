return {
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-cmdline" },
			{
				"petertriho/cmp-git",
				name = "cmp_git",
				dependencies = { "nvim-lua/plenary.nvim" },
				config = true,
			},
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-vsnip" },
			{ "hrsh7th/vim-vsnip", dependencies = { "rafamadriz/friendly-snippets" } },
			{ "lukas-reineke/cmp-under-comparator" },
			{ "quangnguyen30192/cmp-nvim-tags" },
		},
		config = function()
			local cmp = require("cmp")
			local types = require("cmp.types")
			local cmdline_mapping = cmp.mapping.preset.cmdline({
				["<C-j>"] = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
				["<C-k>"] = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
			})
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				sorting = {
					comparators = {
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.score,
						require("cmp-under-comparator").under,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = true })
						elseif vim.fn["vsnip#available"](1) ~= 0 then
							vim.api.nvim_feedkeys(
								vim.api.nvim_replace_termcodes("<Plug>(vsnip-expand-or-jump)", true, false, true),
								"n",
								false
							)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if vim.fn["vsnip#jumpable"](-1) ~= 0 then
							vim.api.nvim_feedkeys(
								vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-prev)", true, false, true),
								"n",
								false
							)
						else
							fallback()
						end
					end),
					["<C-Space>"] = cmp.mapping.complete({}),
					["<C-j>"] = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
					["<C-k>"] = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp_signature_help" },
					{ name = "nvim_lsp" },
					{ name = "vsnip" },
					{ name = "tags" },
					{
						name = "buffer",
						option = {
							get_bufnrs = function()
								local bufs = {}
								for _, win in ipairs(vim.api.nvim_list_wins()) do
									local b = vim.api.nvim_win_get_buf(win)
									local size = vim.api.nvim_buf_get_offset(b, vim.api.nvim_buf_line_count(b))
									if size <= 2 * 1024 * 1024 then
										bufs[#bufs + 1] = b
									end
								end
								return bufs
							end,
						},
					},
				}, {
					{ name = "git" },
				}),
			})
			cmp.setup.cmdline("/", {
				mapping = cmdline_mapping,
				sources = cmp.config.sources({
					{ name = "buffer" },
				}),
			})
			cmp.setup.cmdline("?", {
				mapping = cmdline_mapping,
				sources = cmp.config.sources({
					{ name = "buffer" },
				}),
			})
			cmp.setup.cmdline(":", {
				mapping = cmdline_mapping,
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				dependencies = "nvim-telescope/telescope.nvim",
				build = "make",
				config = function()
					require("telescope").load_extension("fzf")
				end,
			},
			{
				"nvim-telescope/telescope-ui-select.nvim",
				dependencies = "nvim-telescope/telescope.nvim",
				config = function()
					require("telescope").load_extension("ui-select")
				end,
			},
			{
				"smartpde/telescope-recent-files",
				keys = {
					{
						"<Space>h",
						function()
							require("telescope").extensions.recent_files.pick()
						end,
						desc = "telescope recent files",
					},
				},
				dependencies = "nvim-telescope/telescope.nvim",
				config = function()
					require("telescope").load_extension("recent_files")
				end,
			},
		},
		cmd = "Telescope",
		keys = {
			{ "g!", "<Cmd>lua require('skippi.picker').pkill()<CR>" },
			{ "<C-q>", "<Cmd>Telescope quickfix<CR>" },
			{ "<C-s>", "<Cmd>lua require('skippi.picker').tselect()<CR>" },
			{ "<Space>F", ":lua require('telescope.builtin').fd{cwd=''}<Left><Left>" },
			{ "<Space>f", "<Cmd>Telescope find_files<CR>" },
			{ "<Space>g", "<Cmd>Telescope git_files<CR>" },
			{ "<Space>.", "<Cmd>Telescope resume<CR>" },
			{ "<Space><BS>", "<Cmd>Telescope buffers<CR>" },
			{
				"z/",
				function()
					require("telescope.builtin").current_buffer_fuzzy_find({ previewer = false })
				end,
			},
		},
		opts = function()
			local actions = require("telescope.actions")
			return {
				defaults = require("telescope.themes").get_ivy({
					mappings = {
						i = {
							["<C-a>"] = actions.toggle_all,
							["<C-q>"] = require("skippi.actions").send_to_qflist,
							["<C-r><C-w>"] = require("skippi.actions").insert_cword,
							["<C-r><C-a>"] = require("skippi.actions").insert_cWORD,
						},
					},
					layout_config = { height = 17 },
					results_title = "",
					selection_caret = "  ",
					cache_picker = {
						num_pickers = 10,
					},
				}),
				extensions = {
					fzf = {
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			}
		end,
	},
	{
		"chomosuke/term-edit.nvim",
		event = "TermEnter",
		config = function()
			require("term-edit").setup({ prompt_end = "%$ " })
		end,
	},
	{
		"simrat39/symbols-outline.nvim",
		cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
		config = function()
			require("symbols-outline").setup({})
		end,
	},
	{
		"tpope/vim-eunuch",
		config = function()
			vim.keymap.set("n", "ZR", [[:Rename! .<C-r>=expand("%:e")<CR><C-B><C-Right><Right>]], {
				desc = "rename current file",
			})
			vim.keymap.set("n", "ZX", "<Cmd>Remove!<CR>", { desc = "delete current file" })
		end,
	},
	{ "tpope/vim-sleuth", event = "BufReadPre" },
	{ "tpope/vim-vinegar", keys = { "-" }, ft = "netrw" },
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "g.", "<Cmd>Gvdiffsplit<CR>")
			vim.keymap.set("n", "g<CR>", "<Cmd>G<CR>")
			vim.keymap.set("n", "g<Space>", ":G<Space>")
			vim.keymap.set("n", "gL", "<Cmd>G log<CR>")
			vim.keymap.set("n", "gb", "<Cmd>G blame<CR>")
		end,
	},
	{
		"ruifm/gitlinker.nvim",
		keys = {
			{ "gX", "<Cmd>lua require('gitlinker').get_buf_range_url('n')<CR>" },
			{ "gX", "<Cmd>lua require('gitlinker').get_buf_range_url('v')<CR>", mode = "x" },
		},
		dependencies = "nvim-lua/plenary.nvim",
		opts = { mappings = nil },
	},
	{ "rbong/vim-flog", cmd = { "Flog", "Floggit", "Flogsplit" }, dependencies = "tpope/vim-fugitive" },
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		event = "LspAttach",
		config = function()
			require("lsp_lines").setup()
			vim.diagnostic.config({ virtual_text = false, virtual_lines = false })
			vim.keymap.set("n", "yr", require("lsp_lines").toggle, { desc = "toggle lsp_lines" })
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { hl = "GitSignsAdd", text = "┃" },
					change = { hl = "GitSignsChange", text = "┃" },
					delete = { hl = "GitSignsDelete", text = "┃" },
					topdelete = { hl = "GitSignsDelete", text = "┃" },
					changedelete = { hl = "GitSignsChange", text = "┃" },
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					local map = function(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end
					map({ "n", "x", "o" }, "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(gs.next_hunk)
						return "<Ignore>"
					end, { expr = true })
					map({ "n", "x", "o" }, "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(gs.prev_hunk)
						return "<Ignore>"
					end, { expr = true })
					map("n", "dp", function()
						if vim.wo.diff then
							return "dp"
						end
						vim.schedule(gs.stage_hunk)
						return "<Ignore>"
					end, { expr = true })
					map("n", "do", function()
						if vim.wo.diff then
							return "do"
						end
						vim.schedule(gs.reset_hunk)
						return "<Ignore>"
					end, { expr = true })
					map("n", "dO", gs.reset_buffer)
					map("n", "dP", gs.stage_buffer)
					map("x", "<M-d>p", ":Gitsigns stage_hunk<CR>")
					map("x", "<M-d>o", ":Gitsigns reset_hunk<CR>")
					map("n", "du", gs.undo_stage_hunk)
					map("n", "dy", gs.preview_hunk)
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { silent = true })
				end,
			})
		end,
	},
}
