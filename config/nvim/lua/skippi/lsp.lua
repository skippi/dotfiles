local M = {}

function M.make_capabilities()
	local cap = vim.lsp.protocol.make_client_capabilities()
	cap = require("cmp_nvim_lsp").update_capabilities(cap)
	cap.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}
	cap.textDocument.completion.completionItem.snippetSupport = true
	cap.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			"additionalTextEdits",
			"detail",
			"documentation",
		},
	}
	return cap
end

function M.on_attach(_, bufnr)
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
	map({ "n", "x" }, "gd", function()
		vim.fn.setreg("/", "\\<" .. vim.fn.expand("<cword>") .. "\\>")
		vim.o.hlsearch = true
		builtin.lsp_definitions()
	end)
	map({ "n", "x" }, "gI", function()
		vim.fn.setreg("/", "\\<" .. vim.fn.expand("<cword>") .. "\\>")
		vim.o.hlsearch = true
		builtin.lsp_implementations()
	end)
	map("n", "gr", function()
		vim.fn.setreg("/", "\\<" .. vim.fn.expand("<cword>") .. "\\>")
		vim.o.hlsearch = true
		builtin.lsp_references()
	end)
	map("n", "m?", function()
		builtin.diagnostics({
			previewer = false,
			wrap_results = true,
		})
	end)
	map("n", "=d", function()
		vim.lsp.buf.format({
			filter = function(client)
				return client.name ~= "tsserver" or client.name ~= "sumneko_lua"
			end,
			bufnr = bufnr,
			timeout_ms = 2000,
		})
	end)
end

return M
