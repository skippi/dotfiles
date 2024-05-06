local M = {}

function M.find_all_modified(state)
	local result = {}
	-- https://springrts.com/wiki/Lua_Performance#TEST_9:_for-loops
	local bufs = vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1, bufmodified = 1 })
	for i = 1, #bufs do
		local b = bufs[i]
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
		vim.cmd("sil! " .. table.concat(bufnrs, ",") .. "bufdo! sil!update")
	end)
end

return M
