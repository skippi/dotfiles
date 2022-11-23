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
			local actions = require("telescope.actions")
			require("telescope").setup({
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
			vim.keymap.set("n", "<Space><BS>", builtin.buffers)
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
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(gs.next_hunk)
						return "<Ignore>"
					end, { expr = true })
					map("n", "[c", function()
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
	})
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-calc" },
			{ "hrsh7th/cmp-cmdline", commit = "6d45c70" }, -- don't update until visual cmdline fixed
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-vsnip" },
			{ "hrsh7th/vim-vsnip" },
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
	})
	use({
		"neovim/nvim-lspconfig",
		requires = {
			{ "jose-elias-alvarez/nvim-lsp-ts-utils", requires = "nvim-lua/plenary.nvim" },
			"williamboman/mason.nvim",
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
		end,
	})
	use({
		"williamboman/mason.nvim",
		requires = { "williamboman/mason-lspconfig.nvim" },
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()
		end,
	})
	use({
		"ray-x/go.nvim",
		requires = { "neovim/nvim-lspconfig" },
		ft = "go",
		cond = function()
			return vim.loop.os_uname().sysname == "Linux"
		end,
		config = function()
			require("go").setup({})
		end,
	})
	use({
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
	})
	use({
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			require("lsp_lines").setup()
			vim.diagnostic.config({ virtual_text = false, virtual_lines = false })
			vim.keymap.set("n", "yr", require("lsp_lines").toggle, { desc = "toggle lsp_lines" })
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
			vim.keymap.set("x", "<C-a>", require("dial.map").inc_visual())
			vim.keymap.set("x", "<C-x>", require("dial.map").dec_visual())
			vim.keymap.set("x", "g<C-a>", require("dial.map").inc_gvisual())
			vim.keymap.set("x", "g<C-x>", require("dial.map").dec_gvisual())
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
		requires = {
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
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["ai"] = "@block.outer",
							["ii"] = "@block.inner",
						},
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
	use({
		"tpope/vim-eunuch",
		config = function()
			vim.keymap.set("n", "c.", [[:Rename! .<C-r>=expand("%:e")<CR><C-B><C-Right><Right>]], {
				desc = "rename current file",
			})
			vim.keymap.set("n", "d.", "<Cmd>Remove!<CR>", { desc = "delete current file" })
		end,
	})
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
	use({ "rbong/vim-flog", requires = "tpope/vim-fugitive" })
	use({
		"ruifm/gitlinker.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("gitlinker").setup({ mappings = nil })
			vim.keymap.set("n", "gy", "<Cmd>lua require('gitlinker').get_buf_range_url('n')<CR>")
			vim.keymap.set("x", "gy", "<Cmd>lua require('gitlinker').get_buf_range_url('v')<CR>")
		end,
	})
	use({
		"ThePrimeagen/harpoon",
		requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			vim.keymap.set("n", "m.", require("harpoon.mark").add_file, { desc = "add harpoon file" })
			vim.keymap.set("n", "<Space>m", require("harpoon.ui").toggle_quick_menu, { desc = "show harpoon menu" })
		end,
	})
	use({
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
	})
	use({ "kana/vim-textobj-entire", requires = "kana/vim-textobj-user" })
	use({ "Julian/vim-textobj-variable-segment", requires = "kana/vim-textobj-user" })
	use({
		"elihunter173/dirbuf.nvim",
		config = function()
			require("dirbuf").setup({ sort_order = "directories_first" })
		end,
	})
	use("tpope/vim-obsession")
	use("tpope/vim-repeat")
	use("tpope/vim-sleuth")
	use("tpope/vim-unimpaired")
	use({
		"tpope/vim-surround",
		config = function()
			vim.g.surround_13 = "\n\r\n"
			vim.g.surround_indent = 1
		end,
	})

	-- UI
	use({
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				filetypes = {
					"css",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					html = { mode = "foreground" },
				},
			})
		end,
	})
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
	use({
		"tomasiser/vim-code-dark",
		config = function()
			vim.api.nvim_create_autocmd("ColorScheme", {
				desc = "skippi: add gitsigns color",
				pattern = "*",
				callback = function()
					vim.cmd("hi GitSignsAdd guifg=#5D7D20")
					vim.cmd("hi GitSignsChange guifg=#37718C")
					vim.cmd("hi GitSignsDelete guifg=#95161B")
				end,
			})
			vim.cmd("silent! colorscheme codedark")
		end,
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
