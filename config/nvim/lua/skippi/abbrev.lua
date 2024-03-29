local M = {}

function M.create_short_cmds(abbr, expand)
	local str = ""
	local add = false
	for i = 1, #abbr do
		local c = abbr:sub(i, i)
		if c ~= "[" and c ~= "]" then
			str = str .. c
		else
			add = true
		end
		if add then
			vim.cmd(
				"cnoreabbrev <expr> "
					.. str
					.. [[ (getcmdtype() ==# ':' && getcmdline() =~# "^\\('.*,'.*\\)\\?]]
					.. str
					.. [[") ? "]]
					.. expand
					.. [[" : "]]
					.. str
					.. '"'
			)
		end
	end
	if not add then
		vim.cmd(
			"cnoreabbrev <expr> "
				.. str
				.. [[ (getcmdtype() ==# ':' && getcmdline() =~# "^\\('.*,'.*\\)\\?]]
				.. str
				.. [[") ? "]]
				.. expand
				.. [[" : "]]
				.. str
				.. '"'
		)
	end
end

return M
