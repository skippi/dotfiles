local buffers = require("skippi.buffers")

vim.keymap.set({ "n", "v", "o" }, "q", "q", { buffer = true })
vim.keymap.set("n", "sb", [[<Cmd>G reset --soft HEAD^<CR>]], { buffer = true })
vim.keymap.set("n", "sb", [[<Cmd>G commit -c ORIG_HEAD<CR>]], { buffer = true })

local group = vim.api.nvim_create_augroup("skippi.fugitive", { clear = true })

local changedticks = {}
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
	group = group,
	buffer = 0,
	desc = "auto reload fugitive",
	callback = function()
		local bufs = buffers.find_all_modified(changedticks)
		if next(bufs) ~= nil then
			buffers.bulk_write(bufs)
			vim.schedule(vim.cmd.edit)
		end
	end,
})
