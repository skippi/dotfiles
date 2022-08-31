local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")

local M = {}

function M.send_to_qflist(prompt_bufnr)
	actions.smart_send_to_qflist(prompt_bufnr)
	local post_cmd = "cc"
	if vim.bo.syntax == "qf" then
		post_cmd = post_cmd .. "|" .. vim.fn.winnr() .. "wincmd w"
	end
	vim.cmd(post_cmd)
end

function M.insert_cword(prompt_bufnr)
	local picker = action_state.get_current_picker(prompt_bufnr)
	local word = vim.api.nvim_win_call(picker.original_win_id, function()
		return vim.fn.expand("<cword>")
	end)
	vim.fn.feedkeys(word)
end

function M.insert_cWORD(prompt_bufnr)
	local picker = action_state.get_current_picker(prompt_bufnr)
	local word = vim.api.nvim_win_call(picker.original_win_id, function()
		return vim.fn.expand("<cWORD>")
	end)
	vim.fn.feedkeys(word)
end

return M
