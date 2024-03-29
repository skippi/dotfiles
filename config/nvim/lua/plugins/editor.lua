return {
	{
		"hrsh7th/nvim-cmp",
		keys = {
			{
				"yo<C-x>",
				function()
					vim.g.__skippi_cmp_disabled = not vim.g.__skippi_cmp_disabled
					vim.notify("cmp.enabled = " .. tostring(not vim.g.__skippi_cmp_disabled), vim.log.levels.INFO)
				end,
			},
		},
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "lukas-reineke/cmp-under-comparator" },
			{
				"L3MON4D3/LuaSnip",
				dependencies = { "rafamadriz/friendly-snippets" },
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local types = require("cmp.types")
			local cmdline_mapping = cmp.mapping.preset.cmdline({
				["<C-j>"] = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
				["<C-k>"] = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
			})
			cmp.setup({
				enabled = function()
					return not vim.g.__skippi_cmp_disabled and vim.bo.filetype ~= "TelescopePrompt"
				end,
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				sorting = {
					priority_weight = 2,
					comparators = {
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.score,
						cmp.config.compare.recently_used,
						require("cmp-under-comparator").under,
						cmp.config.compare.locality,
						cmp.config.compare.kind,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() and require("skippi.util").cursor_has_words_before() then
							cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp_signature_help" },
				}, {
					{ name = "nvim_lsp" },
					{ name = "luasnip", keyword_length = 2 },
				}, {
					{
						name = "buffer",
						keyword_length = 3,
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
					{ name = "cmdline", option = { ignore_cmds = { "Man", "!", "terminal" } } },
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
		},
		cmd = "Telescope",
		keys = {
			{ "g!", "<Cmd>lua require('skippi.picker').pkill()<CR>" },
			{ "<C-q>", "<Cmd>Telescope quickfix<CR>" },
			{ "<C-s>", "<Cmd>lua require('skippi.picker').tselect()<CR>" },
			{ "<Space>.", "<Cmd>Telescope resume<CR>" },
			{ "<Space>>", "<Cmd>Telescope pickers<CR>" },
			{
				"<Space>/",
				function()
					require("telescope.builtin").live_grep({
						cwd = require("skippi.util").workspace_root() or vim.fn.getcwd(),
					})
				end,
			},
			{ "<Space>?", "<Cmd>Telescope live_grep<CR>" },
			{ "<Space>:", "<Cmd>Telescope commands<CR>" },
			{ "<Space>b", "<Cmd>Telescope buffers<CR>" },
			{ "<Space>d", "<Cmd>Telescope diagnostics bufnr=0<CR>" },
			{ "<Space>D", "<Cmd>Telescope diagnostics<CR>" },
			{
				"<Space>f",
				function()
					require("telescope.builtin").find_files({
						cwd = require("skippi.util").workspace_root() or vim.fn.getcwd(),
					})
				end,
			},
			{ "<Space>F", "<Cmd>Telescope find_files<CR>" },
			{ "<Space>j", "<Cmd>Telescope jumplist<CR>" },
			{ "<Space>l", "<Cmd>Telescope lsp_document_symbols<CR>" },
			{ "<Space>L", "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>" },
			{
				"z/",
				function()
					if vim.bo.buftype == "quickfix" then
						require("telescope.builtin").quickfix({ previewer = false })
					else
						require("telescope.builtin").current_buffer_fuzzy_find({ previewer = false })
					end
				end,
			},
		},
		opts = function()
			local actions = require("telescope.actions")
			return {
				defaults = {
					mappings = {
						i = {
							["<Esc>"] = actions.close,
							["<Tab>"] = actions.move_selection_next,
							["<S-Tab>"] = actions.move_selection_previous,
							["<C-k>"] = actions.toggle_selection + actions.move_selection_better,
							["<C-j>"] = actions.toggle_selection + actions.move_selection_worse,
							["<C-y>"] = require("telescope.actions.layout").toggle_preview,
							["<PageUp>"] = actions.preview_scrolling_up,
							["<PageDown>"] = actions.preview_scrolling_down,
							["<C-u>"] = actions.results_scrolling_up,
							["<C-d>"] = actions.results_scrolling_down,
							["<C-a>"] = actions.toggle_all,
							["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
							["<C-r><C-w>"] = require("skippi.actions").insert_cword,
							["<C-r><C-a>"] = require("skippi.actions").insert_cWORD,
						},
					},
					layout_config = {
						prompt_position = "top",
						width = 0.9,
					},
					sorting_strategy = "ascending",
					results_title = "",
					cache_picker = {
						num_pickers = 20,
					},
				},
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
		"tpope/vim-eunuch",
		config = function()
			vim.keymap.set("n", "ZR", [[:Rename! .<C-r>=expand("%:e")<CR><C-B><C-Right><Right>]], {
				desc = "rename current file",
			})
			vim.keymap.set("n", "ZX", "<Cmd>Remove!<CR>", { desc = "delete current file" })
		end,
	},
	{
		"tpope/vim-dadbod",
		config = function()
			require("skippi.abbrev").create_short_cmds("db", "DB")
		end,
	},
	{ "tpope/vim-characterize", keys = { "ga" } },
	{
		"tpope/vim-sleuth",
		event = "BufReadPre",
		config = function()
			vim.g.sleuth_lua_defaults = "tabstop=2"
		end,
	},
	{
		"tpope/vim-vinegar",
		keys = {
			{
				"-",
				function()
					if vim.v.count == 0 then
						return "<Plug>VinegarUp"
					end
					require("skippi.util").open_buf_in_explorer()
					return "<Ignore>"
				end,
				expr = true,
				desc = "open current file parent directory",
			},
		},
		ft = "netrw",
	},
	{
		"tpope/vim-fugitive",
		dependencies = { "tpope/vim-rhubarb" },
		config = function()
			vim.keymap.set("n", "gX", "<Cmd>.GBrowse<CR>", { silent = true })
			vim.keymap.set("x", "gX", ":GBrowse<CR>", { silent = true })
			vim.keymap.set("n", "g.", "<Cmd>Gvdiffsplit<CR>")
			vim.keymap.set("n", "g<CR>", "<Cmd>G<CR>")
			vim.keymap.set("n", "g<Space>", ":G<Space>")
			vim.keymap.set("n", "gL", function()
				local cmd = "G log"
				if vim.v.count ~= 0 then
					cmd = cmd .. " -n" .. vim.v.count
				end
				vim.cmd(cmd)
			end)
			vim.keymap.set("n", "gb", "<Cmd>G blame<CR>")
		end,
	},
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
					add = { text = "┃" },
					change = { text = "┃" },
					delete = { text = "┃" },
					topdelete = { text = "┃" },
					changedelete = { text = "┃" },
				},
				update_debounce = 200,
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
					local diffp_fn = function()
						if vim.wo.diff then
							return "dp"
						end
						vim.schedule(gs.stage_hunk)
						return "<Ignore>"
					end
					map("n", "dp", diffp_fn, { expr = true })
					map({ "n", "x" }, "mdp", diffp_fn, { expr = true })
					local diffo_fn = function()
						if vim.wo.diff then
							return "do"
						end
						vim.schedule(gs.reset_hunk)
						return "<Ignore>"
					end
					map("n", "do", diffo_fn, { expr = true })
					map({ "n", "x" }, "mdo", diffo_fn, { expr = true })
					map("n", "dO", gs.reset_buffer)
					map("n", "dP", gs.stage_buffer)
					map("n", "du", gs.undo_stage_hunk)
					map("n", "dy", gs.preview_hunk)
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { silent = true })
					map({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", { silent = true })
				end,
			})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = { "leoluz/nvim-dap-go" },
		config = function()
			require("dap-go").setup()
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			modes = {
				search = { enabled = false },
				char = { enabled = false },
			},
		},
		keys = {
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "n", "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
		},
	},
}
