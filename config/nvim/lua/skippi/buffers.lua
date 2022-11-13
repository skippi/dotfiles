local M = {}

function M.find_all_modified(state)
	local result = {}
	for _, b in ipairs(vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1, bufmodified = 1 })) do
		if
			vim.bo[b.bufnr].buftype ~= "terminal"
			and (state == nil or b.changedtick ~= state[b.bufnr])
			and vim.fn.filewritable(b.name) == 1
		then
			result[#result + 1] = b.bufnr
			if state ~= nil then
				state[b.bufnr] = b.changedtick
			end
		end
	end
	return result
end

function M.bulk_write(bufnrs)
	if next(bufnrs) == nil then
		return
	end
	vim.api.nvim_buf_call(bufnrs[1], function()
		vim.cmd(table.concat(bufnrs, ",") .. "bufdo! sil!update")
	end)
end

return M
