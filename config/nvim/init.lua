require("config.lazy")

local buffers = require("skippi.buffers")
local opfunc = require("skippi.opfunc")
local util = require("skippi.util")

vim.g.python3_host_prog = "C:\\Users\\jtbca\\scoop\\apps\\pyenv\\current\\pyenv-win\\versions\\3.10.5\\python.exe"

local function grep_text(cwd)
	local args = {}
	if vim.v.count ~= 0 then
		args[#args + 1] = "-t" .. util.ft_to_ripgrep_type(vim.bo.filetype)
	end
	local search = nil
	if util.edit_mode_is_visual() then
		search = util.visual_selection()
		vim.fn.setreg("/", "\\V" .. vim.fn.escape(search, "\\"))
		args[#args + 1] = "-F"
	else
		local word = vim.fn.expand("<cword>")
		vim.fn.setreg("/", "\\<" .. word .. "\\>")
		search = "\\b" .. word .. "\\b"
	end
	vim.o.hlsearch = vim.o.hlsearch
	require("telescope.builtin").grep_string({
		additional_args = args,
		cwd = cwd,
		search = search,
		use_regex = true,
	})
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
vim.o.ignorecase = true
vim.o.inccommand = "nosplit"
vim.o.mouse = "a"
vim.o.path = ",,**"
vim.o.pumheight = 10
vim.o.ruler = false
vim.o.scrolloff = 4
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

vim.o.statuscolumn = '%r%=%{&rnu>0&&&nu>0?" ":""}%l%s%C'

vim.opt.diffopt:append("linematch:60")
vim.opt.jumpoptions:append({ "stack", "view" })
vim.opt.listchars:append({ eol = "↴" })
vim.opt.shortmess:append("c")
vim.opt.sessionoptions:append("globals,winpos,terminal,folds")

vim.cmd([[
set statusline=
set statusline+=%(\ %{toupper(mode(0))}%)
set statusline+=%(\ @%{FugitiveHead()}%)
set statusline+=%(\ %<%f%)
set statusline+=%=
set statusline+=%([%n]%)
set statusline+=%(%<\ [%{&ff}]\ %y\ %l:%c\ %p%%\ %)
]])

if vim.loop.os_uname().sysname:find("Windows") then
	vim.o.shellslash = true
	vim.o.shellcmdflag = "/s /v /c"
end

util.create_user_command("Browse", function(props)
	local path = props.args
	if props.args == "" then
		path = vim.fn.expand("%:p:h")
	end
	if not util.is_url(path) then
		path = vim.fn.expand(path)
	end
	util.open_file_explorer(path)
end, {
	abbrev = "bro[wse]",
	desc = "open path in file explorer",
	nargs = "?",
	complete = function(arg, _, _)
		-- Need a custom function since "file" completion auto expands symbols like #,%
		return vim.fn.getcompletion(arg, "file")
	end,
})

util.create_user_command(
	"EditCode",
	[[sil exe "!code -ng" expand("%:p") . ":" . line('.') . ":" . col('.') "."]],
	{ abbrev = { "eco[de]" }, desc = "edit in vscode" }
)
util.create_user_command(
	"EditIdea",
	'sil exe "!idea64" expand("%:p") . ":" . line(".")',
	{ abbrev = "ei[dea]", desc = "edit in idea" }
)
util.create_user_command(
	"EditEmacs",
	'sil exe "!emacsclientw -a "" +" .. line(".") .. ":" .. col(".") .. " " .. bufname("%")',
	{ abbrev = "ee[macs]", desc = "edit in emacs" }
)
util.create_user_command(
	"HighlightTest",
	"sil so $VIMRUNTIME/syntax/hitest.vim | set ro",
	{ abbrev = "hit[est]", desc = "test highlight at cursor" }
)
util.create_user_command("Kwbd", "call kwbd#run(<bang>0)", {
	abbrev = "bd[elete]",
	bang = true,
})

util.create_user_command("TrimWS", function()
	local pos = vim.fn.getpos(".")
	vim.cmd([[%s/\s\+$//e]])
	vim.fn.setpos(".", pos)
end, { abbrev = "tri[mws]", desc = "trim whitespace" })

util.create_user_command(
	"Scratch",
	[[enew | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile]],
	{ abbrev = { "scra[tch]", "es[cratch]" } }
)

util.create_user_command("TerminalHere", function()
	vim.cmd.term([[cmd /K "cd ]] .. vim.fn.expand("%:p:h") .. [["]])
end, { abbrev = { "teh[ere]", "terminalh[ere]", "termh[ere]" } })

util.create_command_alias("E", "e")
util.create_command_alias("H", "h")

-- Remove default lsp mappings
vim.keymap.del("n", "grn")
vim.keymap.del("n", "grr")
vim.keymap.del({ "n", "x" }, "gra")

local map = vim.keymap.set

-- PSReadLine bug fixes
map("t", "<M-c>", "<M-c>")
map("t", "<M-h>", "<M-h>")

-- Movement keys in insert mode
local movement_keys = { "<Left>", "<Right>", "<C-Left>", "<C-Right>" }
for _, key in ipairs(movement_keys) do
	map("i", key, "<C-g>U" .. key)
end

map("n", "<C-L>", function()
	if vim.v.count > 0 then
		vim.cmd.edit()
	end
	vim.cmd.noh()
	if vim.fn.has("diff") then
		vim.cmd.diffupdate()
	end
	vim.cmd.redraw()
end, { desc = "redraw / reload screen" })
map({ "n", "i" }, "<Esc>", "<Cmd>noh<CR><Esc>", { silent = true })
map({ "n", "x", "o" }, "'", "`")
map({ "n", "x", "o" }, "gh", "^")
map({ "n", "x", "o" }, "gl", "g_")
map("n", "<BS>", "<C-^>")
map("x", "*", [[:<C-u>let @z=@"<CR>gvymz/\V<C-R>=escape(@", '/\')<CR><CR>:let @"=@z<CR>`z]], { silent = true })
map("x", "#", [[:<C-u>let @z=@"<CR>gvymz?\V<C-R>=escape(@", '?\')<CR><CR>:let @"=@z<CR>`z]], { silent = true })

map("n", "<Space>", "<Nop>")
map("n", "<Space>q", vim.cmd.quit)
map("n", "<Space>a", vim.lsp.buf.code_action)
map("n", "<Space>r", vim.lsp.buf.rename)
map({ "n", "x" }, "gd", function()
	vim.fn.setreg("/", "\\<" .. vim.fn.expand("<cword>") .. "\\>")
	vim.o.hlsearch = true
	require("telescope.builtin").lsp_definitions()
end)
map({ "n", "x" }, "gy", require("telescope.builtin").lsp_type_definitions)
map({ "n", "x" }, "gI", function()
	vim.fn.setreg("/", "\\<" .. vim.fn.expand("<cword>") .. "\\>")
	vim.o.hlsearch = true
	require("telescope.builtin").lsp_implementations()
end)
map("n", "gr", function()
	vim.fn.setreg("/", "\\<" .. vim.fn.expand("<cword>") .. "\\>")
	vim.o.hlsearch = true
	require("telescope.builtin").lsp_references()
end)
map("n", "g/", function()
	local type = ""
	if vim.v.count ~= 0 then
		type = " -t" .. util.ft_to_ripgrep_type(vim.bo.filetype)
	end
	return ':<C-u>sil gr ""' .. type .. "<C-b><C-Right><C-Right><C-Right><Left>"
end, { expr = true, desc = "grep prompt" })
map({ "n", "x" }, "gs", function()
	grep_text(util.workspace_root() or vim.fn.getcwd())
end, { desc = "grep current word or selection in project" })
map({ "n", "x" }, "gS", function()
	grep_text(vim.fn.getcwd())
end, { desc = "grep current word or selection in cwd" })
map("n", "gw", "<C-w>", { remap = true })
map("n", "gW", "gw", { remap = true })
map("n", "m,", "#NcgN")
map("n", "m;", "*Ncgn")
map("x", "m,", "#cgN", { remap = true })
map("x", "m;", "*cgn", { remap = true })
map("!", "<C-r>", "<C-r><C-o>")
map("!", "<C-r><C-o>", "<C-r>")
map("n", "yoq", function()
	local current = vim.diagnostic.config() or {}
	vim.diagnostic.config({ virtual_lines = not current.virtual_lines })
end)

map("n", "[f", function()
	if vim.bo.buftype == "quickfix" then
		vim.cmd("sil!uns colder " .. vim.v.count1)
	else
		util.edit_file_by_offset(-vim.v.count1)
	end
end, { desc = "go to previous file", silent = true })
map("n", "]f", function()
	if vim.bo.buftype == "quickfix" then
		vim.cmd("sil!uns cnewer " .. vim.v.count1)
	else
		util.edit_file_by_offset(vim.v.count1)
	end
end, { desc = "go to next file", silent = true })

map({ "n", "x" }, "j", [[v:count ? 'j' : 'gj']], { desc = "smart j", expr = true })
map({ "n", "x" }, "k", [[v:count ? 'k' : 'gk']], { desc = "smart k", expr = true })

-- Tab navigation mappings
for i = 1, 9 do
	local tab_cmd = string.format("%dgt", i)
	map({ "n", "x" }, "<M-" .. i .. ">", "<Esc>" .. tab_cmd)
	map({ "i", "c" }, "<M-" .. i .. ">", "<Esc>" .. tab_cmd)
	map("t", "<M-" .. i .. ">", "<C-\\><C-n>" .. tab_cmd)
end

for _, op in ipairs({ "p", "P", "y", "Y", "gp", "gP", "=p", "=P" }) do
	map({ "n", "x", "o" }, "<Space>" .. op, '"+' .. op, { remap = true })
end

for key, fn in pairs({
	["<C-d>"] = function()
		local path = vim.fn.expand("%:p:h") .. "/"
		return vim.fn.substitute(path, "\\", "/", "g")
	end,
	["<C-t>"] = function()
		return vim.fn.expand("%:t")
	end,
	["p"] = function()
		local path = vim.fn.expand("%:p")
		if vim.loop.os_uname().sysname:find("Windows") then
			path = vim.fn.substitute(path, "/", "\\", "g")
		end
		return path
	end,
}) do
	map("n", "y" .. key, function()
		vim.fn.setreg(vim.v.register, fn())
	end)
	map("!", "<C-r>" .. key, function()
		return "<C-r>='" .. fn() .. "'<CR>"
	end, { remap = true, expr = true })
end

map("n", "ZF", "gggqG<C-o>")

map({ "x", "o" }, "aj", ":<C-u>norm! 0v$<cr>", { desc = "select line", silent = true })
map({ "x", "o" }, "ij", ":<C-u>norm! _vg_<cr>", { desc = "select inside line", silent = true })

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
		vim.cmd.edit(vim.trim(vim.fn.system({ "wslpath", "-a", name })))
		vim.schedule(function()
			vim.api.nvim_buf_delete(bufnr, { force = true })
		end)
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "term://*",
	group = group,
	callback = function()
		vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]], { buffer = true })
	end,
})

vim.api.nvim_create_autocmd("TermClose", {
	pattern = "term://*",
	group = group,
	command = "Kwbd",
})
