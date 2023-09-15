return {
	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local nls = require("null-ls")
			nls.setup({
				sources = {
					nls.builtins.diagnostics.cppcheck.with({
						extra_args = { "--language=c++" },
					}),
					nls.builtins.diagnostics.eslint_d.with({
						prefer_local = "node_modules/.bin",
					}),
					nls.builtins.diagnostics.gitlint,
					nls.builtins.diagnostics.mypy,
					nls.builtins.formatting.black,
					nls.builtins.formatting.prettier.with({
						prefer_local = "node_modules/.bin",
					}),
					nls.builtins.formatting.stylua,
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"jose-elias-alvarez/typescript.nvim",
			"williamboman/mason.nvim",
			"b0o/schemastore.nvim",
			{
				"folke/neodev.nvim",
				config = function()
					require("neodev").setup({})
				end,
			},
		},
		config = function()
			local lsp = require("skippi.lsp")
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("skippi.lsp.attach", {}),
				callback = function(e)
					lsp.on_attach({}, e.buf)
				end,
			})
			local lsc = require("lspconfig")
			lsc.util.default_config = lsp.make_capabilities()
			lsc.clangd.setup({})
			lsc.dartls.setup({})
			lsc.pyright.setup({})
			lsc.gopls.setup({})
			lsc.lua_ls.setup({
				settings = {
					Lua = {
						completion = {
							callSnippet = "Disable",
						},
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								"${3rd}/luv/library",
							},
						},
					},
				},
			})
			require("typescript").setup({})
			lsc.vimls.setup({})
			lsc.jsonls.setup({
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})
		end,
	},
	{
		"ray-x/go.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		ft = "go",
		config = function()
			require("go").setup({})
		end,
	},
	{
		"barrett-ruth/import-cost.nvim",
		ft = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
		cond = function()
			return vim.loop.os_uname().sysname == "Linux"
		end,
		build = "sh install.sh yarn",
		config = true,
	},
	{
		"mfussenegger/nvim-jdtls",
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = function()
					local on_attach = function(_, bufnr)
						require("jdtls.setup").add_commands()
						vim.api.nvim_buf_create_user_command(
							bufnr,
							"JdtOrganizeImports",
							require("jdtls").organize_imports,
							{ desc = "organize java imports", force = true }
						)
					end
					local project = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
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
}
