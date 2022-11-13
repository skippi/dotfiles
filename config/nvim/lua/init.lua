local abbrev = require("skippi.abbrev")
local buffers = require("skippi.buffers")

local function vim_regex_to_pcre(str)
	str = string.gsub(str, "\\<", "\\b")
	str = string.gsub(str, "\\>", "\\b")
	return str
end

local function visual_selection()
	local mode = vim.fn.mode()
	if mode ~= "v" and mode ~= "V" and mode ~= "CTRL-V" then
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
	if #lines <= 0 then
		return nil
	end
	lines[#lines] = string.sub(lines[#lines], 1, end_col)
	lines[1] = string.sub(lines[1], start_col)
	return table.concat(lines, "\n")
end

local function grep(args)
	local params = ""
	for _, arg in ipairs(args) do
		params = params .. " " .. vim.fn.escape(vim.fn.shellescape(arg, 1), "|")
	end
	vim.cmd("sil grep" .. params)
end

vim.o.autowriteall = true
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
vim.o.sessionoptions = vim.o.sessionoptions .. ",globals"
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

if vim.loop.os_uname().sysname:find("Windows") then
	vim.o.shellcmdflag = "/s /v /c"
end

vim.api.nvim_create_user_command("TrimWS", [[%s/\s\+$//e]], { desc = "trim whitespace", force = true })
abbrev.create_short_cmds("tri[mws]", "TrimWS")

abbrev.create_short_cmds("E", "e")
abbrev.create_short_cmds("H", "h")

local map = vim.keymap.set

map("", "'", "`")
map("", "<Space>P", '"+P', { remap = true })
map("", "<Space>Y", '"+Y', { remap = true })
map("", "<Space>p", '"+p', { remap = true })
map("", "<Space>y", '"+y', { remap = true })
map("", "gh", "^")
map("", "gl", "g_")
map("n", "<BS>", "<C-^>")
map("n", "<C-w>'", function()
	local ESC = 27
	local rc, keynr = pcall(vim.fn.getchar)
	if not rc or keynr == ESC then
		return "<Ignore>"
	end
	return "<C-w>s'" .. vim.fn.nr2char(keynr)
end, { desc = "open new window and jump to mark", expr = true, remap = true })
map("n", "<C-w>gd", "<C-w>sgd", { remap = true })
map("n", "<C-h>", "<BS>", { remap = true }) -- windows <BS> fix
map("n", "<Space>", "<Nop>")
map("n", "<Space>j", ":tag /")
map("n", "<Space>q", "<Cmd>q<CR>")
map("n", "_", function()
	local path = vim.fn.expand("%:p:h")
	if vim.loop.os_uname().sysname:find("Linux") then
		path = vim.fn.system("wslpath -w " .. path .. " | tr -d '\n'") -- xdg-open/wslview are CRAZY bugged on wsl/wt/conemu. Do not use.
	end
	return "<Cmd>sil !explorer '" .. path .. "'<CR>"
end, { desc = "show file in explorer", expr = true })
map("n", "g/", ':sil gr ""<Left>')
map("n", "g<C-s>", function()
	vim.fn.setreg("/", "\\<" .. vim.fn.expand("<cword>") .. "\\>")
	vim.o.hlsearch = true
	grep({ vim_regex_to_pcre(vim.fn.getreg("/")), "--iglob", "*." .. vim.fn.expand("%:e") })
end)
map("n", "g<C-_>", function()
	local fpattern = "*." .. vim.fn.expand("%:e")
	if not vim.loop.os_uname().sysname:find("Windows") then
		fpattern = "\\" .. fpattern
	end
	return ':sil gr "" --iglob ' .. fpattern .. "<C-b><C-Right><C-Right><C-Right><Left>"
end, { expr = true })
map("n", "gs", function()
	vim.fn.setreg("/", "\\<" .. vim.fn.expand("<cword>") .. "\\>")
	vim.o.hlsearch = true
	grep({ vim_regex_to_pcre(vim.fn.getreg("/")) })
end)
map("n", "gw", "<C-w>", { remap = true })
map("n", "m,", "#NcgN")
map("n", "m;", "*Ncgn")
map("n", "yp", function()
	vim.fn.setreg(vim.v.register, vim.fn.expand("%:p"))
end)
map("x", "g<C-s>", function()
	local pattern = visual_selection()
	vim.fn.setreg("/", "\\V" .. vim.fn.escape(pattern, "\\"))
	vim.o.hlsearch = true
	grep({ pattern, "-F", "--iglob", "*." .. vim.fn.expand("%:e") })
end)
map("x", "gs", function()
	local pattern = visual_selection()
	vim.fn.setreg("/", "\\V" .. vim.fn.escape(pattern, "\\"))
	vim.o.hlsearch = true
	grep({ pattern, "-F" })
end)
map("x", "m,", [["zy?\V<C-R>=escape(@z,'/\')<CR><CR>NcgN]])
map("x", "m;", [["zy/\V<C-R>=escape(@z,'/\')<CR><CR>Ncgn]])
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

map("n", "'~", function()
	vim.cmd("sil e " .. vim.fn.stdpath("config") .. "/lua/init.lua")
end, { desc = "jump to init.lua" })
map("n", "'<Tab>", function()
	vim.cmd("sil e " .. vim.fn.stdpath("config") .. "/after/indent/" .. vim.bo.filetype .. ".lua")
end, { desc = "jump to indent config" })
map("n", "'#", function()
	vim.cmd("sil e " .. vim.fn.stdpath("config") .. "/after/syntax/" .. vim.bo.filetype .. ".lua")
end, { desc = "jump to syntax config" })
map("n", "'@", function()
	vim.cmd("sil e " .. vim.fn.stdpath("config") .. "/after/ftplugin/" .. vim.bo.filetype .. ".lua")
end, { desc = "jump to ftplugin config" })
map("n", "'$", function()
	if vim.g.Temp_last_term == nil then
		return
	end
	vim.cmd(vim.g.Temp_last_term .. "b")
end, { desc = "jump to last terminal buffer" })

map({ "n", "x", "o" }, "j", [[v:count ? 'j' : 'gj']], { desc = "smart j", expr = true })
map({ "n", "x", "o" }, "k", [[v:count ? 'k' : 'gk']], { desc = "smart k", expr = true })

map("n", "ZF", "gggqG<C-o>")
map("n", "ZD", "<Cmd>Kwbd<CR>")

map({ "x", "o" }, "aj", ":<C-u>norm! 0v$<cr>", { desc = "select line", silent = true })
map({ "x", "o" }, "ij", ":<C-u>norm! _vg_<cr>", { desc = "select inside line", silent = true })

if vim.loop.os_uname().sysname:find("Windows") then
	map("n", "<C-z>", "<Nop>") -- disable <C-z> windows memory leak
end

local group = vim.api.nvim_create_augroup("skippi", { clear = true })
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

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "yank highlighting",
	group = group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
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

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "lsp attach init",
	group = group,
	callback = function(args)
		vim.bo[args.buf].formatexpr = "v:lua.require('skippi.lsp').formatexpr()"
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "auto trim whitespace",
	group = group,
	pattern = "*",
	callback = function()
		if vim.bo.filetype == "markdown" then
			return
		end
		local pos = vim.fn.getpos(".")
		vim.cmd.TrimWS()
		vim.fn.setpos(".", pos)
	end,
})

vim.api.nvim_create_autocmd({ "FocusLost", "TermEnter" }, {
	desc = "auto save files",
	group = group,
	pattern = "*",
	nested = true,
	callback = function()
		local bufs = buffers.find_all_modified()
		if next(bufs) ~= nil then
			buffers.bulk_write(bufs)
		end
	end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
	desc = "edit windows files",
	group = group,
	pattern = "*",
	nested = true,
	callback = function()
		if not vim.loop.os_uname().sysname:find("Linux") then
			return
		end
		local name = vim.fn.bufname()
		if not name:find("^C:") then
			return
		end
		local bufnr = vim.fn.bufnr()
		vim.cmd("edit " .. vim.trim(vim.fn.system({ "wslpath", "-a", name })))
		vim.schedule(function()
			vim.api.nvim_buf_delete(bufnr, { force = true })
		end)
	end,
})
