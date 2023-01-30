local abbrev = require("skippi.abbrev")
local buffers = require("skippi.buffers")
local opfunc = require("skippi.opfunc")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")

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
vim.o.exrc = true
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
vim.o.smartcase = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true
vim.o.swapfile = false
vim.o.termguicolors = true
vim.o.timeoutlen = 500
vim.o.undofile = true
vim.o.updatetime = 500
vim.o.wildcharm = vim.fn.char2nr(vim.api.nvim_replace_termcodes("<C-z>", true, true, true))
vim.o.wildmode = "list:full"

-- bugged with cmdline window
-- if vim.fn.has('nvim-0.9') == 1 then
	-- vim.o.statuscolumn = "%=%l%s%C"
-- end

vim.opt.diffopt:append("linematch:60")
vim.opt.listchars:append({ eol = "↴" })
vim.opt.shortmess:append("c")
vim.opt.sessionoptions:append("globals")

if vim.loop.os_uname().sysname:find("Windows") then
	vim.o.shellcmdflag = "/s /v /c"
end

vim.api.nvim_create_user_command("TrimWS", function()
	local pos = vim.fn.getpos(".")
	vim.cmd([[%s/\s\+$//e]])
	vim.fn.setpos(".", pos)
end, { desc = "trim whitespace", force = true })
abbrev.create_short_cmds("tri[mws]", "TrimWS")

vim.api.nvim_create_user_command(
	"Scratch",
	[[enew | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile]],
	{ force = true }
)
abbrev.create_short_cmds("scra[tch]", "Scratch")

abbrev.create_short_cmds("E", "e")
abbrev.create_short_cmds("H", "h")

local map = vim.keymap.set

map({ "n", "i" }, "<Esc>", "<Cmd>noh<CR><Esc>", { silent = true })
map({ "n", "x", "o" }, "'", "`")
map({ "n", "x", "o" }, "gh", "^")
map({ "n", "x", "o" }, "gl", "g_")
map("n", "<BS>", "<C-^>")
map("x", "*", [[:<C-u>let @z=@"<CR>gvy/\V<C-R>=escape(@", '/\')<CR><CR>:let @"=@z<CR>]], { silent = true })
map("x", "#", [[:<C-u>let @z=@"<CR>gvy?\V<C-R>=escape(@", '?\')<CR><CR>:let @"=@z<CR>]], { silent = true })

map("n", "<C-w>'", function()
	local ESC = 27
	local rc, keynr = pcall(vim.fn.getchar)
	if not rc or keynr == ESC then
		return "<Ignore>"
	end
	return "<C-w>s'" .. vim.fn.nr2char(keynr)
end, { desc = "open new window and jump to mark", expr = true, remap = true })
map("n", "<C-w>yod", function()
	local wins = vim.api.nvim_tabpage_list_wins(0)
	local diffcmd = "diffoff"
	for _, id in ipairs(wins) do
		if not vim.wo[id].diff then
			diffcmd = "diffthis"
			break
		end
	end
	vim.api.nvim_win_call(0, function()
		vim.cmd("windo " .. diffcmd)
	end)
end, { desc = "toggle window diff" })

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
map("!", "<C-r>", "<C-r><C-o>")
map("!", "<C-r><C-o>", "<C-r>")
map("n", "yd", vim.diagnostic.open_float)
map({ "n", "x", "o" }, "[d", function()
	vim.diagnostic.goto_prev({ float = false })
end)
map({ "n", "x", "o" }, "]d", function()
	vim.diagnostic.goto_next({ float = false })
end)
map({ "n", "x", "o" }, "[w", function()
	vim.diagnostic.goto_prev({ float = false, severity = vim.diagnostic.severity.WARN })
end)
map({ "n", "x", "o" }, "]w", function()
	vim.diagnostic.goto_next({ float = false, severity = vim.diagnostic.severity.WARN })
end)
map({ "n", "x", "o" }, "[e", function()
	vim.diagnostic.goto_prev({ float = false, severity = vim.diagnostic.severity.ERROR })
end)
map({ "n", "x", "o" }, "]e", function()
	vim.diagnostic.goto_next({ float = false, severity = vim.diagnostic.severity.ERROR })
end)

local function edit_file_by_offset(offset)
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
		vim.cmd([[echohl ErrorMsg | echo "No more items" | echohl None]])
		return
	end
	vim.cmd("edit " .. dir .. "/" .. files[idx])
end

map("n", "[f", function()
	if vim.bo.buftype == "quickfix" then
		vim.cmd("sil!uns colder " .. vim.v.count1)
	else
		edit_file_by_offset(-vim.v.count1)
	end
end, { desc = "go to previous file", silent = true })
map("n", "]f", function()
	if vim.bo.buftype == "quickfix" then
		vim.cmd("sil!uns cnewer " .. vim.v.count1)
	else
		edit_file_by_offset(vim.v.count1)
	end
end, { desc = "go to next file", silent = true })

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

map({ "n", "x" }, "j", [[v:count ? 'j' : 'gj']], { desc = "smart j", expr = true })
map({ "n", "x" }, "k", [[v:count ? 'k' : 'gk']], { desc = "smart k", expr = true })

for _, op in ipairs({ "p", "P", "y", "Y", "gp", "gP", "=p", "=P" }) do
	map({ "n", "x", "o" }, "<Space>" .. op, '"+' .. op, { remap = true })
end

for key, fn in pairs({
	["<C-d>"] = function()
		return vim.fn.expand("%:p:h") .. "/"
	end,
	["<C-t>"] = function()
		return vim.fn.expand("%:t")
	end,
	["p"] = function()
		return vim.fn.expand("%:p")
	end,
}) do
	map("n", "y" .. key, function()
		vim.fn.setreg(vim.v.register, fn())
	end)
	map("!", "<C-r>" .. key, function()
		return "<C-r>='" .. fn() .. "'<CR>"
	end, { expr = true })
end

opfunc.map("<C-_>", opfunc.toggle_path_slash, {
	desc = "toggle path slashes",
	expr = true,
})

map("n", "ZF", "gggqG<C-o>")
map("n", "ZD", "<Cmd>Kwbd<CR>")
map("n", "ZS", "<Cmd>Scratch<CR>")

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
		vim.cmd.TrimWS()
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
