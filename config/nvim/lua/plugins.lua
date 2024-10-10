return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
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
			lsc.util.default_config.capabilities = lsp.make_capabilities()
			lsc.clangd.setup({})
			lsc.cssls.setup({})
			lsc.html.setup({})
			lsc.emmet_ls.setup({})
			lsc.dartls.setup({})
			lsc.eslint.setup({})
			lsc.basedpyright.setup({
				settings = {
					basedpyright = {
						typeCheckingMode = "standard",
					},
				},
			})
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
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		ft = {
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
		},
		opts = {},
	},
}
