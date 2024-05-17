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
	vim.cmd("sil !explorer " .. vim.fn.shellescape(win_path, true))
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

function M.first_nonblank_col(lnum)
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
	col = M.first_nonblank_col(lnum) or col
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
	j = M.first_nonblank_col(i + 1) or j
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

function M.expand_alias(alias, command)
	local info = vim.api.nvim_parse_cmd(command, {})
	if vim.fn.getcmdtype() ~= ":" then
		return alias
	end
	local cmdline = vim.fn.getcmdline()
	if cmdline:match("^" .. alias .. "$") then
		return command
	end
	local range_re = vim.regex("^[<>%,'\\.+-]\\+" .. alias .. "$")
	if info.range and range_re:match_str(cmdline) then
		return command
	end
	return alias
end

function M.create_command_alias(abbr, expand)
	local prefix, suffix = abbr:match("([^%[]+)%[?([^%]]*)%]?")
	assert(#prefix, "Command alias must have at least one character")
	local add_alias = function(alias)
		vim.cmd.cnoreabbrev(
			string.format([[<expr> %s v:lua.require("skippi.util").expand_alias("%s", "%s")]], alias, alias, expand)
		)
	end
	add_alias(prefix)
	for i = 1, #suffix do
		add_alias(prefix .. suffix:sub(1, i))
	end
end

function M.ft_to_ripgrep_type(type)
	if type == "text" then
		type = "txt"
	end
	return type
end

function M.is_url(str)
	return str:match("^http[s]?://[%w-_%.%?%.:/%+=&]+")
end

function M.tbl_equal(t1, t2)
	if t1 == t2 then
		return true
	end
	if type(t1) ~= "table" or type(t2) ~= "table" then
		return false
	end
	for key, value in pairs(t1) do
		if not M.tbl_equal(t2[key], value) then
			return false
		end
	end
	for key in pairs(t2) do
		if t1[key] == nil then
			return false
		end
	end
	return true
end

local function find_segment_helper(right_boundary)
	local left_boundaries = table.concat({ "_\\+\\k", "\\<", "\\l\\u", "\\u\\u\\ze\\l", "\\a\\d", "\\d\\a" }, "\\|")
	vim.fn.search(left_boundaries, "bce")
	local start_pos = vim.fn.getpos(".")

	vim.fn.search("\\>", "c")
	local word_end = vim.fn.getpos(".")
	vim.fn.setpos(".", start_pos)

	vim.fn.search(right_boundary, "c")
	for _ = 1, vim.v.count1 - 1 do
		if not M.tbl_equal(vim.fn.getpos("."), word_end) then
			vim.fn.search(right_boundary)
		end
	end
	local end_pos = vim.fn.getpos(".")

	return { start_pos, end_pos }
end

function M.find_segment(ai_type)
	if ai_type == "i" then
		return find_segment_helper(table.concat({ "\\k_", "\\l\\u", "\\u\\u\\l", "\\a\\d", "\\d\\a", "\\k\\>" }, "\\|"))
	end
	local right_boundary = table.concat({ "_", "\\l\\u", "\\u\\u\\l", "\\a\\d", "\\d\\a", "\\k\\>" }, "\\|")
	local start_pos, end_pos = unpack(find_segment_helper(right_boundary))
	local start_row, start_col = start_pos[2], start_pos[3]
	local start_line = vim.fn.getline(start_row)

	vim.fn.search("\\k\\>", "c")
	if M.tbl_equal(end_pos, vim.fn.getpos(".")) and start_line:sub(start_col - 1, start_col - 1):match("_") then
		start_pos[3] = start_pos[3] - 1
	end

	if vim.fn.match(vim.fn.expand("<cword>"), "^_*\\l.*\\u") ~= -1 then
		vim.fn.search("\\<", "bc")
		local word_start = vim.fn.getpos(".")[3]

		if start_col - 2 <= word_start or start_line:sub(1, start_col - 2):match("^_*$") then
			vim.fn.setpos(".", end_pos)
			local tildeop = vim.o.tildeop
			vim.o.tildeop = false
			vim.cmd("normal! l~")
			vim.o.tildeop = tildeop
		end
	end

	return { start_pos, end_pos }
end

return M
