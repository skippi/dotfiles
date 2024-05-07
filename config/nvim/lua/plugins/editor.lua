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
			local deprioritize_emmet = function(a, b)
				if a.source:get_debug_name() == "nvim_lsp:emmet_ls" then
					return false
				end
				if b.source:get_debug_name() == "nvim_lsp:emmet_ls" then
					return true
				end
			end
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
						deprioritize_emmet,
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
								-- https://springrts.com/wiki/Lua_Performance#TEST_9:_for-loops
								local wins = vim.api.nvim_list_wins()
								local bufs = {}
								for i = 1, #wins do
									local win = wins[i]
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
			{ "g]", ":<C-u>TSelect <C-r><C-w><CR>", silent = true },
			{ "g<C-]>", ":<C-u>TJump <C-r><C-w><CR>", silent = true },
			{ "<C-q>", "<Cmd>Telescope quickfix<CR>" },
			{ "<Space>.", "<Cmd>Telescope resume<CR>" },
			{ "<Space>>", "<Cmd>Telescope pickers<CR>" },
			{
				"<Space>/",
				function()
					local util = require("skippi.util")
					local opts = {
						cwd = util.workspace_root() or vim.fn.getcwd(),
					}
					if vim.v.count ~= 0 then
						opts.type_filter = util.ft_to_ripgrep_type(vim.bo.filetype)
					end
					require("telescope.builtin").live_grep(opts)
				end,
			},
			{
				"<Space>?",
				function()
					local util = require("skippi.util")
					local opts = {}
					if vim.v.count ~= 0 then
						opts.type_filter = util.ft_to_ripgrep_type(vim.bo.filetype)
					end
					require("telescope.builtin").live_grep(opts)
				end,
			},
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
			{ '<Space>"', "<Cmd>Telescope registers<CR>" },
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
		config = function(_, opts)
			local picker = require("skippi.picker")
			local util = require("skippi.util")
			util.create_user_command("TSelect", function(params)
				opts = {}
				if #params.args then
					opts.tagname = params.args
				end
				picker.tselect(opts)
			end, {
				abbrev = "ts[elect]",
				desc = "tselect with fuzzy finder",
				nargs = "*",
			})
			util.create_user_command("TJump", function(params)
				opts = {}
				if #params.args then
					opts.tagname = params.args
				end
				picker.tjump(opts)
			end, {
				abbrev = "tj[ump]",
				desc = "tjump with fuzzy finder",
				nargs = "*",
			})
			require("telescope").setup(opts)
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
			require("skippi.util").create_command_alias("db", "DB")
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
					return "<Cmd>Browse<CR>"
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
				local cmd = "G log --oneline"
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
			vim.keymap.set("n", "yoq", require("lsp_lines").toggle, { desc = "toggle lsp_lines" })
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		keys = {
			{ "do", "<Cmd>Diffget<CR>", mode = { "n" } },
			{ "dp", "<Cmd>Diffput<CR>", mode = { "n" } },
			{ "dO", "<Cmd>%Diffget<CR>", mode = { "n" } },
			{ "dP", "<Cmd>%Diffput<CR>", mode = { "n" } },
			{ "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, silent = true },
			{ "ah", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, silent = true },
		},
		config = function()
			local gs = require("gitsigns")
			local util = require("skippi.util")
			util.create_user_command("Diffput", function(args)
				local cmd = ""
				if args.range == 1 then
					cmd = args.line1
				elseif args.range == 2 then
					cmd = args.line1 .. "," .. args.line2
				end
				cmd = cmd .. (vim.wo.diff and "diffput" or "Gitsigns stage_hunk")
				vim.cmd(cmd)
			end, { abbrev = { "diffpu[t]", "dp" }, range = true })
			util.create_user_command("Diffget", function(args)
				local cmd = ""
				if args.range == 1 then
					cmd = args.line1
				elseif args.range == 2 then
					cmd = args.line1 .. "," .. args.line2
				end
				cmd = cmd .. (vim.wo.diff and "diffget" or "Gitsigns reset_hunk")
				vim.cmd(cmd)
			end, { abbrev = { "diffg[et]", "do" }, range = true })
			gs.setup({
				signs = {
					add = { text = "┃" },
					change = { text = "┃" },
					delete = { text = "┃" },
					topdelete = { text = "┃" },
					changedelete = { text = "┃" },
				},
				update_debounce = 200,
				on_attach = function(bufnr)
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
				end,
			})
			local group = vim.api.nvim_create_augroup("skippi.gitsigns", { clear = true })
			vim.api.nvim_create_autocmd("User", {
				pattern = "GitSignsChanged",
				group = group,
				desc = "auto reload fugitive",
				callback = function()
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
						if ft == "fugitive" then
							vim.schedule(function()
								vim.api.nvim_buf_call(buf, vim.cmd.edit) -- refresh the buffer
							end)
						end
					end
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
			prompt = { enabled = false },
			modes = {
				char = { enabled = false },
			},
		},
	},
	{
		"stevearc/oil.nvim",
		cmd = "Oil",
		opts = {
			default_file_explorer = false,
		},
	},
	{ "axelf4/vim-strip-trailing-whitespace" },
	{
		"kwkarlwang/bufjump.nvim",
		opts = {},
	},
}
