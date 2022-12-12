if vim.b.skippi_dirbuf_loaded then
	return
end

local Hydra = require("hydra")
local nav = Hydra({
	name = "Quick Navigation",
	mode = "n",
	body = "z",
	config = { buffer = true },
	heads = {
		{ "h", "<Plug>(dirbuf_up)", { silent = true, exit = true } },
		{ "l", "<Plug>(dirbuf_enter)", { desc = "←/→", silent = true, exit = true } },
		{ "j", "<Down>", { silent = true } },
		{ "k", "<Up>", { desc = "↑/↓", silent = true } },
	},
})
nav:activate()
vim.keymap.set("n", "z", function()
	nav:activate()
end, { buffer = true, silent = true, nowait = true })
vim.keymap.set("n", "<C-j>", "<Plug>(dirbuf_enter)", { buffer = true, silent = true })

vim.b.skippi_dirbuf_loaded = true
