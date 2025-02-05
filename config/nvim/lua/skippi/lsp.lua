local M = {}

function M.make_capabilities()
	local cap = require("lspconfig").util.default_config.capabilities
	cap = require("blink.cmp").get_lsp_capabilities(cap)
	cap.semanticTokensProvider = nil
	cap.textDocument.completion.completionItem.snippetSupport = true
	cap.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}
	return cap
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
		require("skippi.util").format()
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
