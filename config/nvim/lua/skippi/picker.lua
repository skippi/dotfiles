local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")

local M = {}

local function echoerr(msg)
	vim.cmd("echohl ErrorMsg")
	vim.cmd('echomsg "' .. msg .. '"')
	vim.cmd("echohl None")
end

local function trim(s)
	return s:gsub("^%s*(.-)%s*$", "%1")
end

local function getprocitems()
	local cmd = "tasklist /fo csv /nh"
	if vim.loop.os_uname().sysname:find("Linux") then
		cmd = [[ps --no-header -o %p -o ,%a x]]
	end
	local output = vim.fn.systemlist(cmd)
	local results = {}
	for _, s in ipairs(output) do
		local splited = {}
		for v in s:gmatch('[^,]+') do
			splited[#splited + 1] = v
		end
		results[#results + 1] = {
			pid = tonumber(splited[1]),
			filename = splited[2],
		}
	end
	return results
end

function M.pkill(opts)
	local displayer = entry_display.create({
		separator = " | ",
		items = {
			{ width = 5 },
			{ remaining = true },
		},
	})
	local make_display = function(entry)
		return displayer({
			{ entry.pid, "TelescopeResultsSpecialComment" },
			{ entry.filename },
		})
	end
	pickers.new(opts, {
		prompt_title = "Kill Process",
		finder = finders.new_table({
			results = getprocitems(),
			entry_maker = function(entry)
				return {
					valid = true,
					display = make_display,
					ordinal = entry.filename .. " " .. entry.pid,
					filename = entry.filename,
					pid = entry.pid,
				}
			end,
		}),
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(_, map)
			local smart_kill_action = function(prompt_bufnr, _)
				local picker = action_state.get_current_picker(prompt_bufnr)
				local items = {}
				if #picker:get_multi_selection() > 0 then
					for _, entry in ipairs(picker:get_multi_selection()) do
						table.insert(items, entry)
					end
				else
					for entry in picker.manager:iter() do
						table.insert(items, entry)
					end
				end
				for _, entry in ipairs(items) do
					local cmd = "taskkill /f /pid "
					if vim.loop.os_uname().sysname:find("Linux") then
						cmd = "kill -9 "
					end
					vim.fn.jobstart(cmd .. entry.pid)
				end
				actions.close(prompt_bufnr)
			end
			actions.select_default:replace(smart_kill_action)
			map("n", "<C-d>", smart_kill_action)
			map("i", "<C-d>", smart_kill_action)
			return true
		end,
	}):find()
end

function M.tselect(opts)
	local stack = vim.fn.gettagstack()
	local item = stack.items[stack.curidx - 1]
	if not item then
		echoerr("E73: tag stack empty")
		return
	end
	local tagexpr = "\\c^" .. item.tagname .. "$"
	if item.tagname:find("^/") ~= nil then
		tagexpr = item.tagname:sub(2)
	end
	local results = vim.fn.taglist(tagexpr)
	if #results == 0 then
		echoerr("E492: tag not found: " .. item.tagname)
		return
	end
	pickers.new(opts, {
		prompt = "Tags",
		finder = finders.new_table({
			results = results,
			entry_maker = function(item)
				if item.cmd == "" or item.cmd:sub(1, 1) == "!" then
					return nil
				end
				local scode = item.cmd:sub(2, item.cmd:len() - 1)
				local value = trim(scode:sub(2, scode:len() - 1))
				return {
					valid = true,
					ordinal = value .. " " .. item.filename,
					value = value,
					display = function(entry)
						local displayer = entry_display.create({
							separator = " | ",
							items = {
								{ width = 22 },
								{ remaining = true },
							},
						})
						return displayer({
							vim.fn.pathshorten(entry.filename),
							entry.ordinal,
						})
					end,
					name = item.name,
					filename = item.filename,
					scode = scode,
					lnum = 1,
				}
			end,
		}),
		sorter = conf.generic_sorter(opts),
		attach_mappings = function()
			action_set.select:enhance({
				post = function()
					vim.cmd("keepjumps norm! gg")
					vim.fn.search(action_state.get_selected_entry().scode)
				end,
			})
			return true
		end,
	}):find()
end

return M
