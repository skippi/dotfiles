vim.keymap.set({ "n", "v", "o" }, "q", "q")
vim.keymap.set("n", "sb", [[<Cmd>G reset --soft HEAD^<CR>]])
vim.keymap.set("n", "sb", [[<Cmd>G commit -c ORIG_HEAD<CR>]])

local group = vim.api.nvim_create_augroup("skippi.fugitive", { clear = true })

local changedticks = {}
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
	group = group,
	buffer = 0,
	desc = "auto reload fugitive",
	callback = function()
		local modified = false
		for _, b in ipairs(vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1, bufmodified = 1 })) do
			if vim.bo[b.bufnr].buftype ~= "terminal" and b.changedtick ~= changedticks[b.bufnr] then
				modified = true
				changedticks[b.bufnr] = b.changedtick
			end
		end
		if modified then
			vim.cmd.wall()
			vim.defer_fn(function()
				vim.cmd("edit")
			end, 0)
		end
	end,
})
