local M = {}

function M.make_capabilities()
	local cap = require("lspconfig").util.default_config.capabilities
	cap = vim.tbl_deep_extend("force", cap, require("cmp_nvim_lsp").default_capabilities())
	cap.semanticTokensProvider = nil
	cap.textDocument.completion.completionItem.snippetSupport = true
	cap.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}
	return cap
end

function M.on_attach(_, bufnr)
	local map = function(mode, key, cmd, opts)
		opts = opts or {}
		opts.buffer = bufnr
		vim.keymap.set(mode, key, cmd, opts)
	end
	map("n", "<Space><Space>", vim.lsp.buf.rename)
	map("n", "<Space>a", vim.lsp.buf.code_action)
	map("n", "<Space>k", vim.lsp.buf.hover)
	map({ "n", "x" }, "gd", function()
		vim.fn.setreg("/", "\\<" .. vim.fn.expand("<cword>") .. "\\>")
		vim.o.hlsearch = true
		require("telescope.builtin").lsp_definitions()
	end)
	map({ "n", "x", "o" }, "gy", require("telescope.builtin").lsp_type_definitions)
	map({ "n", "x" }, "gI", function()
		vim.fn.setreg("/", "\\<" .. vim.fn.expand("<cword>") .. "\\>")
		vim.o.hlsearch = true
		require("telescope.builtin").lsp_implementations()
	end)
	map("n", "gr", function()
		vim.fn.setreg("/", "\\<" .. vim.fn.expand("<cword>") .. "\\>")
		vim.o.hlsearch = true
		require("telescope.builtin").lsp_references()
	end)
end

function M.formatexpr(opts)
	if vim.bo.filetype:find("commit") then
		return 1
	end
	if vim.tbl_contains({ "i", "R", "ic", "ix" }, vim.fn.mode()) then
		-- `formatexpr` is also called when exceeding `textwidth` in insert mode
		-- fall back to internal formatting
		return 1
	end
	local conform = require("conform")
	local start_lnum = vim.v.lnum
	local end_lnum = start_lnum + vim.v.count - 1
	if start_lnum == 1 and end_lnum == vim.fn.line("$") then
		conform.format({
			async = true,
			lsp_fallback = true,
			filter = function(client)
				return client.name ~= "tsserver" and client.name ~= "lua_ls"
			end,
			timeout_ms = 10000,
		})
		return 0
	end
	return conform.formatexpr(opts)
end

local function nvim_buf_temp_call(...)
	local old_view = vim.fn.winsaveview()
	vim.api.nvim_buf_call(...)
	vim.fn.winrestview(old_view)
end

local function invoke_tagfunc(tagname, flags, info)
	assert(#vim.bo.tagfunc > 0, "vim.bo.tagfunc must be set")
	local tag_fn = assert(loadstring("return " .. vim.bo.tagfunc:sub(7) .. "(...)"))
	return tag_fn(tagname, flags, info)
end

function M.taglist(tagname, pos)
	local results
	if vim.bo.tagfunc ~= "" then
		if pos then
			nvim_buf_temp_call(pos[1], function()
				vim.fn.setpos(".", pos)
				results = invoke_tagfunc(tagname, "c", { buf_ffname = vim.fn.expand("%:p") })
			end)
		else
			results = invoke_tagfunc(tagname, "r")
			if results ~= nil and results ~= vim.NIL then
				results = vim.fn.matchfuzzy(results, tagname, { key = "name" })
			end
		end
	end
	if results == nil or results == vim.NIL then
		results = vim.fn.taglist(("^%s$"):format(tagname), vim.fn.bufname())
	end
	if results == nil or results == vim.NIL then
		results = {}
	end
	return results
end


return M
