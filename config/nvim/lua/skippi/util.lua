local M = {}

function M.cursor_has_words_before()
	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
		return false
	end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

function M.workspace_root()
	local dir = vim.fn.system("git rev-parse --show-toplevel")
	if vim.v.shell_error ~= 0 then
		return nil
	end
	return vim.trim(dir)
end

function M.open_file_explorer(path)
	if vim.loop.os_uname().sysname:find("Linux") then
		path = vim.fn.system("wslpath -w " .. path .. " | tr -d '\n'") -- xdg-open/wslview are CRAZY bugged on wsl/wt/conemu. Do not use.
	end
	local win_path = path:gsub("/", "\\")
	vim.cmd("sil !explorer " .. vim.fn.shellescape(win_path))
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
	table.sort(files, function(a, b)
		return a:lower() < b:lower()
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
	vim.cmd.edit(dir .. "/" .. files[idx])
end

local function first_nonblank_col(lnum)
	local nonblank_col = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]:find("%S")
	if nonblank_col == nil then
		return nil
	end
	return nonblank_col - 1
end

function M.jump_treesitter_statement(offset)
	if vim.tbl_contains({
		"gitcommit",
		"help",
		"txt",
	}, vim.bo.filetype) then
		return false
	end
	local lnum, col = unpack(vim.api.nvim_win_get_cursor(0))
	col = first_nonblank_col(lnum) or col
	local ok, node = pcall(vim.treesitter.get_node, { bufnr = 0, pos = { lnum - 1, col } })
	if not ok or node == nil or node:type() == "comment" then
		return false
	end
	local i, j = node:range()
	for _ = 1, math.abs(offset) do
		local sr = node:range()
		while i == sr do
			if offset < 0 then
				node = node:prev_named_sibling() or node:parent()
			else
				while node do
					if node:next_named_sibling() then
						node = node:next_named_sibling()
						break
					end
					node = node:parent()
				end
			end
			if node == nil then
				break
			end
			i, j = node:range()
		end
	end
	j = first_nonblank_col(i + 1) or j
	vim.api.nvim_buf_set_mark(0, "'", i + 1, j, {})
	vim.api.nvim_win_set_cursor(0, { i + 1, j })
	return true
end

function M.create_user_command(name, command, opts)
	if opts.abbrev ~= nil then
		if type(opts.abbrev) == "string" then
			opts.abbrev = { opts.abbrev }
		end
		for _, a in ipairs(opts.abbrev) do
			M.create_command_alias(a, name)
		end
		opts.abbrev = nil
	end
	vim.api.nvim_create_user_command(name, command, opts)
end

function M.visual_selection()
	assert(M.edit_mode_is_visual(), "not in visual mode")
	vim.cmd.visual()
	local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
	local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))
	if start_row > end_row or (start_row == end_row and start_col > end_col) then
		start_row, end_row = end_row, start_row
		start_col, end_col = end_col, start_col
	end
	local lines = vim.fn.getline(start_row, end_row)
	if #lines <= 0 then
		return nil
	end
	lines[#lines] = string.sub(lines[#lines], 1, end_col)
	lines[1] = string.sub(lines[1], start_col)
	return table.concat(lines, "\n")
end

function M.edit_mode_is_visual()
	return vim.tbl_contains({ "v", "V", "CTRL-V" }, vim.fn.mode())
end

function M.create_command_alias(abbr, expand)
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
			vim.cmd.cnoreabbrev(
				"<expr> "
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
		vim.cmd.cnoreabbrev(
			"<expr> "
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

function M.ft_to_ripgrep_type(type)
	if type == "text" then
		type = "txt"
	end
	return type
end

return M
