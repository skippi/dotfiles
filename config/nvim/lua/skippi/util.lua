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

return M
