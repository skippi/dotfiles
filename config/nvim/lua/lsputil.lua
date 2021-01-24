local lsp = require('vim.lsp')

local M = {}

local function ifilter(list, fn)
  local result = {}
  for _, v in ipairs(list) do
    if fn(v) then table.insert(result, v) end
  end
  return result
end

local function strlcp(str1, str2)
  local maxdist = math.min(str1:len(), str2:len())
  for i = 1,maxdist do
    if str1:sub(i, i) ~= str2:sub(i, i) then
      return i - 1
    end
  end
  return maxdist
end

function M.attach(client)
  vim.api.nvim_buf_set_option(0, 'omnifunc', "v:lua.lsputil.omnifunc")
end

function M.omnifunc(findstart, base)
  if vim.tbl_isempty(vim.lsp.buf_get_clients()) then
    if findstart == 1 then
      return -1
    else
      return {}
    end
  end

  local pos = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local line_to_cursor = line:sub(1, pos[2])
  local textMatch = vim.fn.match(line_to_cursor, '\\k*$')
  local prefix = line_to_cursor:sub(textMatch+1)

  local complete_item_is_match = function(v)
    if prefix == '' then return true end
    if prefix == prefix:lower() then
      return vim.fn.matchstr(v.word, '\\c^' .. prefix) ~= ''
    else
      return vim.startswith(v.word, prefix)
    end
  end

  local complete_item_cmp = function(a, b)
    alcp = strlcp(a.word, prefix) 
    blcp = strlcp(b.word, prefix)
    if alcp > blcp then return true end
    if alcp == blcp then
      if a.word:len() < b.word:len() then return true end
      if a.word:len() == b.word:len() and a.word < b.word then
        return true
      end
    end
    return false
  end

  local params = lsp.util.make_position_params()

  local bufnr = vim.api.nvim_get_current_buf()
  lsp.buf_request(bufnr, 'textDocument/completion', params, function(err, _, result)
    if err or not result then return end
    local items = lsp.util.text_document_completion_list_to_complete_items(result, '')
    items = ifilter(items, complete_item_is_match)
    table.sort(items, complete_item_cmp)
    vim.fn.complete(textMatch+1, items)
  end)

  -- Return -2 to signal that we should continue completion so that we can
  -- async complete.
  return -2
end

lsputil = M

return M
