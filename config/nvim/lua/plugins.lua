return {
	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local nls = require("null-ls")
			nls.setup({
				on_attach = require("skippi.lsp").on_attach,
				sources = {
					nls.builtins.diagnostics.cppcheck.with({
						extra_args = { "--language=c++" },
					}),
					nls.builtins.diagnostics.eslint_d.with({
						prefer_local = "node_modules/.bin",
					}),
					nls.builtins.diagnostics.gitlint,
					nls.builtins.diagnostics.mypy,
					nls.builtins.formatting.prettier.with({
						prefer_local = "node_modules/.bin",
					}),
					nls.builtins.formatting.stylua,
				},
			})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
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
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
				end,
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-calc" },
			{ "hrsh7th/cmp-cmdline", commit = "6d45c70" }, -- don't update until visual cmdline fixed
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-vsnip" },
			{ "hrsh7th/vim-vsnip" },
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
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-j>"] = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
					["<C-k>"] = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp_signature_help" },
					{ name = "nvim_lua" },
					{ name = "nvim_lsp" },
					{ name = "vsnip" },
					{ name = "calc" },
					{ name = "tags" },
					{
						name = "buffer",
						option = {
							get_bufnrs = function()
								local bufs = {}
								for _, win in ipairs(vim.api.nvim_list_wins()) do
									bufs[vim.api.nvim_win_get_buf(win)] = true
								end
								return vim.tbl_keys(bufs)
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
					{ name = "cmdline", keyword_pattern = [=[[^[:blank:]\!]*]=] },
				}),
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "jose-elias-alvarez/nvim-lsp-ts-utils", dependencies = "nvim-lua/plenary.nvim" },
			"williamboman/mason.nvim",
			"b0o/schemastore.nvim",
		},
		config = function()
			local lsc = require("lspconfig")
			local lsp = require("skippi.lsp")
			local opts = { capabilities = lsp.make_capabilities(), on_attach = lsp.on_attach }
			lsc.dartls.setup(opts)
			lsc.pyright.setup(opts)
			lsc.gopls.setup(opts)
			lsc.sumneko_lua.setup({
				on_attach = opts.on_attach,
				capabilities = opts.capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
			local ts_utils = require("nvim-lsp-ts-utils")
			lsc.tsserver.setup({
				init_options = ts_utils.init_options,
				capabilities = opts.capabilities,
				on_attach = function(client, bufnr)
					opts.on_attach(client, bufnr)
					ts_utils.setup({ auto_inlay_hints = false })
					ts_utils.setup_client(client)
				end,
			})
			lsc.vimls.setup(opts)
			lsc.jsonls.setup(vim.tbl_extend("force", opts, {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			}))
		end,
	},
	{
		"williamboman/mason.nvim",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()
		end,
	},
	{
		"ray-x/go.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		ft = "go",
		cond = function()
			return vim.loop.os_uname().sysname == "Linux"
		end,
		config = function()
			require("go").setup({})
		end,
	},
	{
		"mfussenegger/nvim-jdtls",
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = function()
					require("jdtls.setup").add_commands()
					local project = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
					local on_attach = function(client, bufnr)
						require("skippi.lsp").on_attach(client, bufnr)
						vim.api.nvim_buf_create_user_command(
							bufnr,
							"JdtOrganizeImports",
							require("jdtls").organize_imports,
							{ desc = "organize java imports", force = true }
						)
					end
					local config = {
						cmd = {
							"jdtls",
							"-configuration",
							vim.fn.stdpath("data") .. "/mason/packages/jdtls/config_linux",
							"-data",
							os.getenv("HOME") .. "/src/workspace/" .. project,
						},
						flags = {
							allow_incremental_sync = true,
						},
						settings = {
							java = {
								codeGeneration = {
									toString = {
										template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
									},
								},
							},
						},
						capabilities = require("skippi.lsp").make_capabilities(),
						on_attach = on_attach,
					}
					config.on_init = function(client, _)
						client.notify("workspace/didChangeConfiguration", { settings = config.settings })
					end
					require("jdtls").start_or_attach(config)
				end,
			})
		end,
	},
	{
		"mattn/emmet-vim",
		setup = function()
			vim.g.user_emmet_leader_key = "<Space>e"
			vim.g.user_emmet_mode = "nv"
		end,
	},
	"lewis6991/impatient.nvim",
	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({
				icons = false,
			})
			vim.keymap.set("n", "<Space>t", ":TroubleToggle<CR>")
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
	"rafamadriz/friendly-snippets",
	"skippi/vim-abolish",
	"tpope/vim-commentary",
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
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "g.", "<Cmd>Gvdiffsplit<CR>")
			vim.keymap.set("n", "g<CR>", "<Cmd>G<CR>")
			vim.keymap.set("n", "g<Space>", ":G<Space>")
			vim.keymap.set("n", "gL", "<Cmd>G log<CR>")
			vim.keymap.set("n", "gb", "<Cmd>G blame<CR>")
		end,
	},
	{ "rbong/vim-flog", dependencies = "tpope/vim-fugitive" },
	{
		"ruifm/gitlinker.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("gitlinker").setup({ mappings = nil })
			vim.keymap.set("n", "gy", "<Cmd>lua require('gitlinker').get_buf_range_url('n')<CR>")
			vim.keymap.set("x", "gy", "<Cmd>lua require('gitlinker').get_buf_range_url('v')<CR>")
		end,
	},
	{
		"ThePrimeagen/harpoon",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			vim.keymap.set("n", "m.", require("harpoon.mark").add_file, { desc = "add harpoon file" })
			vim.keymap.set("n", "<Space>m", require("harpoon.ui").toggle_quick_menu, { desc = "show harpoon menu" })
		end,
	},
	{
		"gbprod/substitute.nvim",
		config = function()
			require("substitute").setup({})
			vim.keymap.set("n", "s", require("substitute").operator)
			vim.keymap.set("n", "ss", require("substitute").line)
			vim.keymap.set("n", "S", require("substitute").eol)
			vim.keymap.set("x", "s", require("substitute").visual)
			vim.keymap.set({ "n", "x" }, "<Space>s", '"+s', { remap = true })
			vim.keymap.set("n", "cx", require("substitute.exchange").operator)
			vim.keymap.set("n", "cxx", require("substitute.exchange").line)
			vim.keymap.set("x", "X", require("substitute.exchange").visual)
			vim.keymap.set("n", "cxc", require("substitute.exchange").cancel)
		end,
	},
	{
		"chomosuke/term-edit.nvim",
		config = function()
			require("term-edit").setup({ prompt_end = "%$ " })
		end,
	},
	{
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({})
		end,
	},
	"tpope/vim-repeat",
	"tpope/vim-unimpaired",
	{
		"tpope/vim-surround",
		config = function()
			vim.g.surround_13 = "\n\r\n"
			vim.g.surround_indent = 1
		end,
	},
}
