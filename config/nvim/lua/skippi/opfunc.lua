local M = {}

local current_fn = nil

function M.transform(type)
	local sel_save = vim.o.selection
	local reg_save = vim.fn.getreginfo('"')
	local cb_save = vim.o.clipboard
	local start_v = vim.fn.getpos("'<")
	local end_v = vim.fn.getpos("'>")
	pcall(function()
		vim.o.clipboard = ""
		vim.o.selection = "inclusive"
		local commands = {
			line = "'[V']y",
			char = "`[v`]y",
			block = "`[\\<c-v>`]y",
		}
		vim.cmd("silent noautocmd keepjumps normal! " .. commands[type])
		vim.fn.setreg('"', current_fn(vim.fn.getreg('"')))
		vim.cmd("norm! gvp")
	end)
	vim.fn.setreg('"', reg_save)
	vim.fn.setpos("'<", start_v)
	vim.fn.setpos("'>", end_v)
	vim.o.clipboard = cb_save
	vim.o.selection = sel_save
end

vim.cmd([[
function! __skippi_transform_opfunc(motion) abort
	return v:lua.require('skippi.opfunc').transform(a:motion)
endfunction
]])

local function transform_setup(fn)
	current_fn = fn
	vim.o.opfunc = "__skippi_transform_opfunc"
	return "g@"
end

function M.win_path_to_wsl(str)
	return vim.trim(vim.fn.system({ "wslpath", "-a", str }))
end

function M.wsl_path_to_win(str)
	return vim.trim(vim.fn.system({ "wslpath", "-a", "-m", str }))
end

function M.toggle_path_slash(str)
	if str:find("\\") then
		return vim.fn.substitute(str, "\\", "/", "g")
	end
	return vim.fn.substitute(str, "/", "\\", "g")
end

function M.map(input, transform, opts)
	local callback = function()
		return transform_setup(transform)
	end
	vim.keymap.set({ "n", "x" }, input, callback, opts)
	vim.keymap.set("n", input .. input, callback, opts)
end

return M
