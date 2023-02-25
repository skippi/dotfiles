local Hydra = require("hydra")
local widgets = require("dap.ui.widgets")

local M = {}

local hint = [[
  ^ ^        Debug
  ^
  _b_ Toggle breakpoint
  _c_ Continue program execution
  _i_ Step in
  _o_ Step out
  _n_ Step to next
  _v_ List variables
  _t_ Terminate debug session
  _s_ Switch stack frame
  ^
       ^^^^                   _<Esc>_
]]

local scopeViews = {}
local frameViews = {}

M.debug = Hydra({
	name = "Debug",
	hint = hint,
	config = {
		color = "amaranth",
		hint = {
			border = "single",
			position = "bottom-right",
		},
	},
	heads = {
		{ "b", '<Cmd>lua require("dap").toggle_breakpoint()<CR>' },
		{
			"c",
			function()
				require("dap").continue()
			end,
			{ exit = true },
		},
		{ "i", '<Cmd>lua require("dap").step_into()<CR>' },
		{ "o", '<Cmd>lua require("dap").step_out()<CR>' },
		{ "n", '<Cmd>lua require("dap").step_over()<CR>' },
		{
			"v",
			function()
				local bufnr = vim.fn.bufnr()
				local sidebar = scopeViews[bufnr] or widgets.sidebar(widgets.scopes)
				sidebar.toggle()
				scopeViews[bufnr] = sidebar
			end,
		},
		{ "t", '<Cmd>lua require("dap").terminate()<CR>', { exit = true } },
		{
			"s",
			function()
				local bufnr = vim.fn.bufnr()
				local sidebar = frameViews[bufnr] or widgets.sidebar(widgets.scopes)
				sidebar.toggle()
				frameViews[bufnr] = sidebar
			end,
		},
		{ "p", "<Space>gp", { remap = true, exit = true } },
		{ "P", "<Space>gP", { remap = true, exit = true } },
		{ "<Esc>", nil, { exit = true } },
	},
})

return M
