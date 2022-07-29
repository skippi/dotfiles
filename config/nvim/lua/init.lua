local function vim_regex_to_pcre(str)
	str = string.gsub(str, "\\<", "\\b")
	str = string.gsub(str, "\\>", "\\b")
	str = vim.fn.escape(str, "%#")
	return str
end

local function visual_selection()
	local mode = vim.fn.mode()
	if mode ~= "v" or mode ~= "V" or mode ~= "CTRL-V" then
		return nil
	end
	vim.cmd([[visual]])
	local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
	local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))
	if start_row > end_row or (start_row == end_row and start_col > end_col) then
		start_row, end_row = end_row, start_row
		start_col, end_col = end_col, start_col
	end
	local lines = vim.fn.getline(start_row, end_row)
	local n = 0
	for _ in pairs(lines) do
		n = n + 1
	end
	if n <= 0 then
		return nil
	end
	lines[n] = string.sub(lines[n], 1, end_col)
	lines[1] = string.sub(lines[1], start_col)
	return table.concat(lines, "\n")
end

local function star_grep(pattern, args)
	vim.fn.setreg("/", pattern)
	vim.cmd("sil!keepj norm! nN")
	local grep_cmd = "sil gr " .. vim_regex_to_pcre(pattern)
	if args ~= nil then
		grep_cmd = grep_cmd .. " " .. table.concat(args, " ")
	end
	vim.cmd(grep_cmd)
end

vim.o.cmdwinheight = 7
vim.o.completeopt = "menuone,noselect"
vim.o.completeslash = "slash"
vim.o.fileformat = "unix"
vim.o.fileformats = "unix,dos"
vim.o.grepformat = "%f:%l:%c:%m,%f:%l:%m"
vim.o.grepprg = "rg --smart-case --follow --hidden --vimgrep --glob !.git"
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.inccommand = "nosplit"
vim.o.joinspaces = false
vim.o.mouse = "a"
vim.o.path = ",,**"
vim.o.pumheight = 10
vim.o.ruler = false
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.smartcase = true
vim.o.swapfile = false
vim.o.termguicolors = true
vim.o.timeoutlen = 500
vim.o.undofile = true
vim.o.updatetime = 500
vim.o.wildcharm = vim.fn.char2nr(vim.api.nvim_replace_termcodes("<C-z>", true, true, true))
vim.o.wildmode = "list:full"

vim.o.shiftwidth = 2
vim.o.tabstop = 2

if vim.loop.os_uname().sysname == "win32" then
	vim.o.shellcmdflag = "/s /v /c"
end

local map = vim.keymap.set

map("", "'", "`")
map("", "<Space>P", '"+P', { remap = true })
map("", "<Space>Y", '"+Y', { remap = true })
map("", "<Space>p", '"+p', { remap = true })
map("", "<Space>y", '"+y', { remap = true })
map("", "gh", "^")
map("", "gl", "g_")
map("n", "<BS>", "<C-^>")
map("n", "<C-w>gd", "<C-w>sgd", { remap = true })
map("n", "<C-h>", "<BS>", { remap = true }) -- windows <BS> fix
map("n", "<Space>", "<Nop>")
map("n", "<Space>d", "<Cmd>Kwbd<CR>")
map("n", "<Space>j", ":tag /")
map("n", "<Space>q", "<Cmd>q<CR>")
map("n", "_", function()
	local opener = "xdg-open"
	if vim.loop.os_uname().sysname == "Windows" then
		opener = "explorer"
	end
	vim.cmd("silent !" .. opener .. " %:p:h")
end, { desc = "show file in explorer", expr = true })
map("n", "g/", ':sil gr ""<Left>')
map("n", "g<C-s>", function()
	vim.cmd("sil!keepj norm! *N")
	star_grep(vim.fn.getreg("/"), { "--iglob", "*." .. vim.fn.expand("%:e") })
end)
map("n", "g<C-_>", ':sil gr "" --iglob *.<C-r>=expand("%:e")<CR><C-b><C-Right><C-Right><C-Right><Left>')
map("n", "gs", function()
	vim.cmd("sil!keepj norm! *N")
	star_grep(vim.fn.getreg("/"))
end)
map("n", "gw", "<C-w>", { remap = true })
map("n", "m,", "#NcgN")
map("n", "m;", "*Ncgn")
map("n", "yp", function()
	vim.fn.setreg(vim.v.register, vim.fn.expand("%:p"))
end)
map("v", "g<C-s>", function()
	star_grep(visual_selection(), { "--iglob", "*." .. vim.fn.expand("%:e") })
end)
map("v", "gs", function()
	star_grep(visual_selection())
end)
map("v", "m,", [["zy?\V<C-R>=escape(@z,'/\')<CR><CR>NcgN]])
map("v", "m;", [["zy/\V<C-R>=escape(@z,'/\')<CR><CR>Ncgn]])
map({ "i", "c" }, "<C-r><C-d>", '<C-r>=expand("%:p:h")<CR>/')
map("n", "y<C-d>", function()
	vim.fn.setreg(vim.v.register, vim.fn.expand("%:p:h") .. "/")
end)
map({ "i", "c" }, "<C-r><C-t>", '<C-r>=expand("%:t")<CR>')
map("n", "y<C-t>", function()
	vim.fn.setreg(vim.v.register, vim.fn.expand("%:t"))
end)
map("n", "yd", vim.diagnostic.open_float)
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)

if vim.loop.os_uname().sysname == "win32" then
	map("n", "<C-z>", "<Nop>") -- disable <C-z> win32 memory leak
end

local group = vim.api.nvim_create_augroup("skippi", { clear = false })
vim.api.nvim_clear_autocmds({ group = group })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "CursorHold", "CursorHoldI" }, {
	desc = "auto reload file",
	group = group,
	pattern = "*",
	callback = function()
		if vim.fn.mode() ~= "c" then
			vim.cmd("silent! checktime")
		end
	end,
})
vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
	desc = "auto save file",
	group = group,
	pattern = "*",
	callback = function()
		if not vim.bo.modified then
			return
		end
		local change_marks = { vim.fn.getpos("'["), vim.fn.getpos("']") }
		vim.cmd("sil! update")
		vim.fn.setpos("'[", change_marks[1])
		vim.fn.setpos("']", change_marks[2])
	end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "yank highlighting",
	group = group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ on_visual = false })
	end,
})
vim.api.nvim_create_autocmd("BufLeave", {
	desc = "file context marks",
	group = group,
	pattern = "*",
	callback = function()
		local ext = vim.fn.expand("%:e")
		if ext ~= "" then
			vim.cmd("mark " .. ext:sub(1, 1):upper())
		end
	end,
})
vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "jump to last known position",
	group = group,
	pattern = "*",
	callback = function()
		local line = vim.fn.line
		if line("'\"") > 0 and line("'\"") <= line("$") and not vim.bo.filetype:find("commit") then
			vim.cmd('normal! g`"')
		end
	end,
})
