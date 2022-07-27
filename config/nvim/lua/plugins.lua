local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<C-a>"] = require("skippi.actions").toggle_selection_all,
							["<C-q>"] = require("skippi.actions").send_to_qflist,
							["<C-r><C-w>"] = require("skippi.actions").insert_cword,
							["<C-r><C-a>"] = require("skippi.actions").insert_cWORD,
						},
					},
					cache_picker = {
						num_pickers = 10,
					},
				},
				extensions = {
					fzf = {
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("ui-select")
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "g!", require("skippi.picker").pkill)
			vim.keymap.set("n", "<C-q>", builtin.quickfix)
			vim.keymap.set("n", "<C-s>", require("skippi.picker").tselect)
			vim.keymap.set("n", "<Space>F", ":lua require('telescope.builtin').fd{cwd=''}<Left><Left>")
			vim.keymap.set("n", "<Space>f", builtin.find_files)
			vim.keymap.set("n", "<Space>g", builtin.git_files)
			vim.keymap.set("n", "<Space>h", builtin.oldfiles)
			vim.keymap.set("n", "<Space>.", builtin.resume)
			vim.keymap.set("n", "z/", function()
				builtin.current_buffer_fuzzy_find({ previewer = false })
			end)
		end,
	})
	use({
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local nls = require("null-ls")
			nls.setup({
				on_attach = function(_, bufnr)
					local map = function(mode, key, cmd, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, key, cmd, opts)
					end
					map("n", "=d", vim.lsp.buf.formatting)
				end,
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
	})
	use({
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
					map("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
					map("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })
					map("n", "dp", function()
						local diff = vim.api.nvim_win_get_option(0, "diff")
						if diff then
							vim.fn.feedkeys("dp", "n")
							return
						end
						gs.stage_hunk()
					end)
					map("n", "do", function()
						local diff = vim.api.nvim_win_get_option(0, "diff")
						if diff then
							vim.fn.feedkeys("do", "n")
							return
						end
						gs.reset_hunk()
					end)
					map("n", "dO", gs.reset_buffer)
					map("n", "dP", gs.stage_buffer)
					map("v", "<M-d>p", ":Gitsigns stage_hunk<CR>")
					map("v", "<M-d>o", ":Gitsigns reset_hunk<CR>")
					map("n", "du", gs.undo_stage_hunk)
					map("n", "dy", gs.preview_hunk)
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
				end,
			})
		end,
	})
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-calc" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-vsnip" },
			{
				"hrsh7th/vim-vsnip",
				config = function()
					vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/vsnip"
				end,
			},
			{ "quangnguyen30192/cmp-nvim-tags" },
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = cmp.mapping.confirm({ select = true }),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-l>"] = cmp.mapping.complete(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp_signature_help" },
					{ name = "nvim_lsp" },
					{ name = "tags" },
					{ name = "calc" },
					{ name = "vsnip" },
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
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "buffer" },
				}),
			})
			cmp.setup.cmdline("?", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "buffer" },
				}),
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline", keyword_pattern = [=[[^[:blank:]\!]*]=] },
				}),
			})
		end,
	})
	use({
		"kevinhwang91/nvim-ufo",
		requires = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter" },
		config = function()
			-- vim.o.foldcolumn = '1'
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = -1
			vim.o.foldenable = true
			vim.keymap.set("n", "zR", require("ufo").openAllFolds)
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
			require("ufo").setup({
				open_fold_hl_timeout = 0,
				provider_selector = function(bufnr, filetype)
					return { "treesitter", "indent" }
				end,
			})
		end,
	})
	use({
		"neovim/nvim-lspconfig",
		requires = {
			{ "jose-elias-alvarez/nvim-lsp-ts-utils", requires = "nvim-lua/plenary.nvim" },
		},
		config = function()
			local lsc = require("lspconfig")
			local cap = require("skippi.lsp").capabilities
			local on_attach = function(_, bufnr)
				local map = function(mode, key, cmd, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, key, cmd, opts)
				end
				local builtin = require("telescope.builtin")
				map("n", "<C-j>", builtin.lsp_dynamic_workspace_symbols)
				map("n", "<C-k>", vim.lsp.buf.code_action)
				map("n", "K", vim.lsp.buf.hover)
				map("n", "cm", vim.lsp.buf.rename)
				map({ "n", "v" }, "gd", function()
					vim.fn.setreg("/", vim.fn.expand("<cword>"))
					builtin.lsp_definitions()
				end)
				map("n", "gr", function()
					vim.fn.setreg("/", vim.fn.expand("<cword>"))
					builtin.lsp_references()
				end)
				map("n", "m?", function()
					builtin.diagnostics({
						previewer = false,
						wrap_results = true,
					})
				end)
			end
			local opts = { capabilities = cap, on_attach = on_attach }
			lsc.dartls.setup(opts)
			lsc.pyright.setup(opts)
			lsc.gopls.setup(opts)
			lsc.sumneko_lua.setup({
				on_attach = function(client, bufnr)
					opts.on_attach(client, bufnr)
					client.resolved_capabilities.document_formatting = false
					client.resolved_capabilities.document_range_formatting = false
				end,
				capabilities = opts.capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
			lsc.emmet_ls.setup({
				on_attach = opts.on_attach,
				capabilities = opts.capabilities,
				filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
			})
			local ts_utils = require("nvim-lsp-ts-utils")
			lsc.tsserver.setup({
				init_options = ts_utils.init_options,
				capabilities = cap,
				on_attach = function(client, bufnr)
					ts_utils.setup({ auto_inlay_hints = false })
					ts_utils.setup_client(client)
					client.resolved_capabilities.document_formatting = false
					client.resolved_capabilities.document_range_formatting = false
					on_attach(client, bufnr)
				end,
			})
			lsc.vimls.setup(opts)
		end,
	})
	use({
		"mfussenegger/nvim-jdtls",
		ft = "java",
		config = function()
			require("jdtls.ui").pick_one_async = require("skippi.picker").jdtls_ui_picker
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = function()
					require("jdtls").start_or_attach({
						cmd = { "jdtls.bat" },
						capabilities = require("skippi.lsp").capabilities,
					})
				end,
			})
			vim.api.nvim_add_user_command("JdtCompile", require("jdtls").compile, { force = true })
			vim.api.nvim_add_user_command("JdtUpdateConfig", require("jdtls").update_project_config, { force = true })
		end,
	})
	use({
		"wellle/targets.vim",
		config = function()
			vim.fn["targets#mappings#extend"]({
				r = { pair = { { o = "[", c = "]" } } },
			})
		end,
	})
	use("AndrewRadev/splitjoin.vim")
	use({
		"mattn/emmet-vim",
		setup = function()
			vim.g.user_emmet_leader_key = "<Space>e"
			vim.g.user_emmet_mode = "nv"
		end,
	})
	use({
		"monaqa/dial.nvim",
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				default = {
					augend.constant.alias.bool,
					augend.date.alias["%H:%M"],
					augend.date.alias["%Y-%m-%d"],
					augend.date.alias["%Y/%m/%d"],
					augend.integer.alias.binary,
					augend.integer.alias.decimal_int,
					augend.integer.alias.hex,
					augend.semver.alias.semver,
				},
			})
			vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal())
			vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal())
			vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual())
			vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual())
			vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual())
			vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual())
		end,
	})
	use("lewis6991/impatient.nvim")
	use({
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({
				icons = false,
			})
			vim.keymap.set("n", "<Space>t", ":TroubleToggle<CR>")
		end,
	})
	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {},
				highlight = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<M-l>",
						node_incremental = "<M-l>",
						scope_incremental = "<M-;>",
						node_decremental = "<M-h>",
					},
				},
			})
		end,
	})
	use({
		"andymass/vim-matchup",
		requires = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			vim.g.matchup_matchparen_enabled = 0
			vim.g.matchup_matchparen_offscreen = {}
			vim.g.matchup_surround_enabled = 1
			vim.g.matchup_transmute_enabled = 0
			require("nvim-treesitter.configs").setup({
				matchup = { enable = true },
			})
		end,
	})
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})
	use("skippi/vim-abolish")
	use("tpope/vim-commentary")
	use("tpope/vim-eunuch")
	use({
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "g.", "<Cmd>Gvdiffsplit<CR>")
			vim.keymap.set("n", "g<CR>", "<Cmd>G<CR>")
			vim.keymap.set("n", "g<Space>", ":G<Space>")
			vim.keymap.set("n", "gL", "<Cmd>G log --first-parent<CR>")
			vim.keymap.set("n", "gb", "<Cmd>G blame<CR>")
		end,
	})
	use("tpope/vim-obsession")
	use("tpope/vim-projectionist")
	use("tpope/vim-repeat")
	use("tpope/vim-sleuth")
	use({
		"tpope/vim-surround",
		config = function()
			vim.g.surround_13 = "\n\r\n"
			vim.g.surround_indent = 1
		end,
	})
	use("tpope/vim-vinegar")
	use({
		"windwp/nvim-ts-autotag",
		requires = { "nvim-treesitter/nvim-treesitter" },
		ft = {
			"html",
			"xml",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	})

	-- UI
	use("tomasiser/vim-code-dark")
	use({
		"MaxMEllon/vim-jsx-pretty",
		ft = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
	})
	use({ "MTDL9/vim-log-highlighting", ft = "log" })
	use({ "pprovost/vim-ps1", ft = "ps1" })

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
