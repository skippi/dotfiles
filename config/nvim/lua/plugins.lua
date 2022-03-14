local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
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
		end,
	})
	use({
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local nls = require("null-ls")
			nls.setup({
				on_attach = require("skippi.lsp").on_attach,
				sources = {
					nls.builtins.code_actions.gitsigns,
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
							vim.fn.feedkeys("dp")
							return
						end
						gs.stage_hunk()
					end)
					map("n", "do", function()
						local diff = vim.api.nvim_win_get_option(0, "diff")
						if diff then
							vim.fn.feedkeys("do")
							return
						end
						gs.reset_hunk()
					end)
					map("n", "dO", gs.reset_buffer)
					map("n", "dP", gs.stage_buffer)
					map("v", "<C-p>", ":Gitsigns stage_hunk<CR>")
					map("v", "<C-o>", ":Gitsigns reset_hunk<CR>")
					map("n", "du", gs.undo_stage_hunk)
					map("n", "dy", gs.preview_hunk)
				end,
			})
		end,
	})
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-nvim-lsp" },
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
				mapping = {
					["<CR>"] = function(fallback)
						if cmp.visible() and cmp.get_selected_entry() ~= nil then
							cmp.confirm({ select = true })
						else
							cmp.close()
							fallback()
						end
					end,
					["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i" }),
					["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i" }),
					["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
					["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
					["<C-y>"] = cmp.config.disable,
					["<C-e>"] = cmp.mapping({
						i = cmp.mapping.abort(),
						c = cmp.mapping.close(),
					}),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "tags" },
					{ name = "vsnip" },
					{ name = "buffer" },
				}),
			})
			cmp.setup.cmdline("/", {
				sources = cmp.config.sources({
					{ name = "buffer" },
				}),
			})
			cmp.setup.cmdline("?", {
				sources = cmp.config.sources({
					{ name = "buffer" },
				}),
			})
			cmp.setup.cmdline(":", {
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline", keyword_pattern = [=[[^[:blank:]\!]*]=] },
				}),
			})
		end,
	})
	use({
		"neovim/nvim-lspconfig",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			{ "jose-elias-alvarez/nvim-lsp-ts-utils", requires = "nvim-lua/plenary.nvim" },
		},
		config = function()
			local lsc = require("lspconfig")
			local cap = vim.lsp.protocol.make_client_capabilities()
			cap = require("cmp_nvim_lsp").update_capabilities(cap)
			cap.textDocument.completion.completionItem.snippetSupport = true
			cap.textDocument.completion.completionItem.resolveSupport = {
				properties = {
					"additionalTextEdits",
					"detail",
					"documentation",
				},
			}
			local opts = { capabilities = cap, on_attach = require("skippi.lsp").on_attach }
			lsc.dartls.setup(opts)
			lsc.pyright.setup(opts)
			local ts_utils = require("nvim-lsp-ts-utils")
			lsc.tsserver.setup({
				init_options = ts_utils.init_options,
				capabilities = cap,
				on_attach = function(client, bufnr)
					ts_utils.setup({ auto_inlay_hints = false })
					ts_utils.setup_client(client)
					client.resolved_capabilities.document_formatting = false
					client.resolved_capabilities.document_range_formatting = false
					require("skippi.lsp").on_attach(client, bufnr)
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
			vim.g.user_emmet_leader_key = "m."
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
			vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
			vim.api.nvim_set_keymap("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
			vim.api.nvim_set_keymap("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
			vim.api.nvim_set_keymap("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
			vim.api.nvim_set_keymap("v", "g<C-a>", require("dial.map").inc_gvisual(), { noremap = true })
			vim.api.nvim_set_keymap("v", "g<C-x>", require("dial.map").dec_gvisual(), { noremap = true })
		end,
	})
	use("lewis6991/impatient.nvim")
	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = "maintained",
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
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})
	use("tpope/vim-abolish")
	use("tpope/vim-commentary")
	use("tpope/vim-eunuch")
	use("tpope/vim-fugitive")
	use("tpope/vim-obsession")
	use("tpope/vim-projectionist")
	use("tpope/vim-repeat")
	use({
		"tpope/vim-sleuth",
		commit = "e726df55a669f02699b7ac396011315370752f4e",
	})
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
	if packer_bootstrap then
		require("packer").sync()
	end
end)
