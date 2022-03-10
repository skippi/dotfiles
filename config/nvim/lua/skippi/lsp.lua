local M = {}

M.on_attach = function(client, bufnr)
	local map = function(mode, key, cmd, opts)
		opts = opts or {}
		opts.buffer = bufnr
		vim.keymap.set(mode, key, cmd, opts)
	end
	map("n", "=d", vim.lsp.buf.formatting)
end

return M
