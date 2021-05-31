local action_set = require('telescope.actions.set')
local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local conf = require('telescope.config').values
local entry_display = require('telescope.pickers.entry_display')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local previewers = require('telescope.previewers')

local M = {}

local function getprocitems()
  local output = vim.fn.system("tasklist /fo csv /nh")
  local results = {}
  for s in output:gmatch("[^\r\n]+") do
    local splited = {}
    for v in s:gmatch("[^,\"]+") do
      splited[#splited + 1] = v
    end
    results[#results + 1] = {
      pid = tonumber(splited[2]),
      filename = splited[1],
    }
  end
  return results
end

function M.pkill(opts)
  local displayer = entry_display.create{
    separator = ' | ',
    items = {
      { width = 5 },
      { remaining = true },
    },
  }
  local make_display = function(entry)
    return displayer{
      { entry.pid, 'TelescopeResultsSpecialComment' },
      { entry.filename },
    }
  end
  pickers.new(opts, {
    prompt_title = "Kill Process",
    finder = finders.new_table{
      results = getprocitems(),
      entry_maker = function(entry)
        return {
          valid = true,
          display = make_display,
          ordinal = entry.filename .. ' ' .. entry.pid,
          filename = entry.filename,
          pid = entry.pid,
        }
      end
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function()
      action_set.select:replace(function(prompt_bufnr, _)
        local picker = action_state.get_current_picker(prompt_bufnr)
        local entries = {action_state.get_selected_entry()}
        for _, entry in ipairs(picker:get_multi_selection()) do
          entries[#entries + 1] = entry
        end
        actions.close(prompt_bufnr)
        for _, entry in ipairs(entries) do
          vim.api.nvim_command("sil exe \"!taskkill /f /pid "
            .. entry.pid
            .. "\"")
        end
      end)
      return true
    end,
  }):find()
end

function M.jdtls_ui_picker(items, prompt, label_fn, cb)
  local opts = {}
  pickers.new(opts, {
    prompt_title = prompt,
    finder    = finders.new_table {
      results = items,
      entry_maker = function(entry)
        return {
          value = entry,
          display = label_fn(entry),
          ordinal = label_fn(entry),
        }
      end,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = actions.get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)
        cb(selection.value)
      end)
      return true
    end,
  }):find()
end

function M.tags(opts)
  local displayer = entry_display.create{
    separator = " │ ",
    items = {
      { remaining = true },
    },
  }
  local make_display = function(entry)
    return displayer{
      entry.ordinal,
    }
  end
  local entry_maker = function(item)
    if item.cmd == '' or item.cmd:sub(1, 1) == '!' then
      return nil
    end
    return {
      valid = true,
      ordinal = (item.namespace and item.namespace .. "::" or "") .. (item.class and item.class .. "." or "") .. item.name .. (item.signature or ""),
      display = make_display,
      name = item.name,
      filename = item.filename,
      scode = item.cmd:sub(2, item.cmd:len() - 1),
      lnum = 1,
    }
  end
  local results = assert(vim.fn.taglist(opts.search and '\\C^' .. opts.search .. '$' or '.*'))
  if #results == 0 then
    vim.cmd("echohl ErrorMsg")
    vim.cmd('echomsg "E492: tag not found: ' .. opts.search .. '"')
    vim.cmd("echohl None")
    return
  elseif #results == 1 then
    vim.cmd("mark '")
    vim.cmd("e " .. results[1].filename)
    vim.cmd('keepjumps norm! gg')
    vim.fn.search(results[1].cmd:sub(2, results[1].cmd:len() - 1))
    vim.cmd('norm! zz')
    return
  end
  pickers.new(opts, {
    prompt = 'Tags',
    finder = finders.new_table {
      results = results,
      entry_maker = entry_maker,
    },
    previewer = previewers.ctags.new(opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function()
      action_set.select:enhance {
        post = function()
          vim.cmd('keepjumps norm! gg')
          vim.fn.search(action_state.get_selected_entry().scode)
          vim.cmd('norm! zz')
        end,
      }
      return true
    end
  }):find()
end

return M
