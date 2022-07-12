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

return M
