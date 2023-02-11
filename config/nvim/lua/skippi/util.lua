local M = {}

function M.open_buf_in_explorer()
	local path = vim.fn.expand("%:p:h")
	if vim.loop.os_uname().sysname:find("Linux") then
		path = vim.fn.system("wslpath -w " .. path .. " | tr -d '\n'") -- xdg-open/wslview are CRAZY bugged on wsl/wt/conemu. Do not use.
	end
	vim.cmd("sil !explorer " .. vim.fn.shellescape(path))
end

function M.jump_diagnostic(count, severity)
	local opts = { float = false, wrap = false }
	if type(severity) ~= "table" then
		opts.severity = severity
	end
	for _ = 1, math.abs(count) do
		if count > 0 then
			vim.diagnostic.goto_next(opts)
		else
			vim.diagnostic.goto_prev(opts)
		end
	end
end

function M.edit_file_by_offset(offset)
	local dir = vim.fn.expand("%:h")
	if not vim.fn.isdirectory(dir) then
		return
	end
	local files = vim.fn.readdir(dir, function(f)
		return vim.fn.isdirectory(dir .. "/" .. f) == 0
	end)
	local idx = -math.huge
	for i, v in ipairs(files) do
		if v == vim.fn.expand("%:t") then
			idx = i
			break
		end
	end
	idx = idx + offset
	if not (1 <= idx and idx <= #files) then
		vim.notify("No more items", vim.log.levels.ERROR)
		return
	end
	vim.cmd("edit " .. dir .. "/" .. files[idx])
end

return M
