local M = {}

function M.open_buf_in_explorer()
	local path = vim.fn.expand("%:p:h")
	if vim.loop.os_uname().sysname:find("Linux") then
		path = vim.fn.system("wslpath -w " .. path .. " | tr -d '\n'") -- xdg-open/wslview are CRAZY bugged on wsl/wt/conemu. Do not use.
	end
	vim.cmd("sil !explorer " .. vim.fn.shellescape(path))
end

return M
