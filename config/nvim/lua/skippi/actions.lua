local action_set = require('telescope.actions.set')
local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')

local M = {}

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

return M
