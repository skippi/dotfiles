local M = {}

function M.trim_whitespace()
  vim.api.nvim_command("%s/\\s\\+$//e")
end

return M
