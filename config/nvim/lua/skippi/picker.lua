local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")

local M = {}

local function getprocitems()
	local cmd, match
	local is_linux = vim.loop.os_uname().sysname:find("Linux")
	if is_linux then
		cmd = [[ps --no-header -o args:200 -o \0%p x]]
		match = "[^\\x00]+"
	else
		cmd = "tasklist /fo csv /nh"
		match = '[^",]+'
	end
	local output = vim.fn.systemlist(cmd)
	local results = {}
	for _, s in ipairs(output) do
		local splited = {}
		for v in s:gmatch(match) do
			splited[#splited + 1] = v
		end
		if is_linux then
			results[#results + 1] = {
				filename = table.concat(splited, "", 1, #splited - 1),
				pid = tonumber(splited[#splited]),
			}
		else
			results[#results + 1] = {
				filename = splited[1],
				pid = tonumber(splited[2]),
			}
		end
	end
	return results
end

function M.pkill(opts)
	local make_display = function(entry)
		local displayer = entry_display.create({
			separator = " | ",
			items = {
				{ width = 5 },
				{ remaining = true },
			},
		})
		return displayer({
			{ entry.pid, "TelescopeResultsSpecialComment" },
			{ entry.filename },
		})
	end
	pickers
		.new(opts, {
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
		})
		:find()
end

local function nvim_buf_temp_call(...)
	local old_view = vim.fn.winsaveview()
	vim.api.nvim_buf_call(...)
	vim.fn.winrestview(old_view)
end

local function find_tags_from_tagstack(item)
	local results = nil
	nvim_buf_temp_call(item.from[1], function()
		vim.fn.setpos(".", item.from)
		local filename = vim.fn.bufname()
		if vim.bo.tagfunc ~= "" then
			local tag_fn = assert(loadstring("return " .. vim.bo.tagfunc:sub(7) .. "(...)"))
			results = tag_fn(item.tagname, "c", { buf_ffname = filename })
		end
		if results == nil or results == vim.NIL then
			results = vim.fn.taglist(("^%s$"):format(item.tagname), filename)
		end
	end)
	return results
end

local function make_entry_from_tag(item)
	return vim.tbl_extend("force", item, {
		ordinal = item.text .. " " .. item.filename,
		value = item,
		display = function(entry)
			local displayer = entry_display.create({
				separator = " ",
				items = {
					{ width = 22 },
					{ remaining = true },
				},
			})
			return displayer({
				vim.fn.pathshorten(vim.fn.fnamemodify(entry.filename, ":~:.")),
				entry.text,
			})
		end,
	})
end

function M.tselect(opts)
	opts = opts or {}
	local stack = vim.fn.gettagstack()
	local stack_item = stack.items[stack.curidx - 1]
	if stack_item == nil then
		vim.notify("E73: tag stack empty", vim.log.levels.ERROR)
		return
	end
	local results = find_tags_from_tagstack(stack_item)
	if #results == 0 then
		vim.notify("E492: tag not found: " .. stack_item.tagname, vim.log.levels.ERROR)
		return
	end
	results = { unpack(results, 1, 128) }
	for _, tag in ipairs(results) do
		if tag.cmd:find("^/%^") ~= nil then
			local lines = vim.fn.readfile(tag.filename, "")
			local pat = tag.cmd:gsub("^/%^", "\\V"):gsub("/$", ""):gsub("%$$", "")
			local idx = vim.fn.match(lines, pat)
			if idx ~= -1 then
				tag.text = lines[idx + 1]
				tag.lnum = idx + 1
			else
				tag.text = pat
				tag.lnum = 1
			end
		else
			tag.bufnr = vim.fn.bufnr(tag.filename, true)
			nvim_buf_temp_call(tag.bufnr, function()
				vim.cmd("keepjumps " .. tag.cmd)
				tag.text = vim.api.nvim_get_current_line()
				local pos = vim.fn.getcurpos()
				tag.lnum = pos[2]
				tag.col = pos[3]
			end)
		end
	end
	pickers
		.new(opts, {
			prompt_title = "Tags",
			finder = finders.new_table({
				results = results,
				entry_maker = make_entry_from_tag,
			}),
			previewer = conf.grep_previewer(opts),
			sorter = conf.generic_sorter(opts),
		})
		:find()
end

return M
