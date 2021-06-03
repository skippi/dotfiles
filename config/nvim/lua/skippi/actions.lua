local action_set = require('telescope.actions.set')
local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')

local M = {}

local function entry_to_qf(entry)
  return {
    bufnr = entry.bufnr,
    filename = entry.filename,
    lnum = entry.lnum,
    col = entry.col,
    text = entry.text or entry.value.text or entry.value,
  }
end

function M.toggle_selection_all(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  for entry in picker.manager:iter() do
    if not picker:is_multi_selected(entry) then
      picker._multi:toggle(entry)
    end
  end
  for row = 0,picker.max_results do
    local entry = picker.manager:get_entry(picker:get_index(row))
    picker.highlighter:hi_multiselect(row, picker._multi:is_selected(entry))
  end
end

function M.send_to_qflist(prompt_bufnr)
  local qf_entries = {}
  for entry in action_state.get_current_picker(prompt_bufnr).manager:iter() do
    table.insert(qf_entries, entry_to_qf(entry))
  end
  actions.close(prompt_bufnr)
  vim.fn.setqflist(qf_entries)
end

return M
