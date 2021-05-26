local entry_display = require('telescope.pickers.entry_display')

local M = {}

function M.gen_from_ctags(opts)
  local displayer = entry_display.create{
    separator = " │ ",
    items = {
      { width = 30 },
      { remaining = true },
    },
  }
  local make_display = function(entry)
    return displayer{
      entry.filename,
      entry.tag,
    }
  end
  return function(line)
    if line == '' or line:sub(1, 1) == '!' then
      return nil
    end
    local tag, file, scode, tail = string.match(line, '([^\t]+)\t([^\t]+)\t/^\t?(.*)/;"\t+[a-z](.*)')
    local fields = {}
    for kv in tail:gmatch('\t[a-z]+:[^\t\r\n]+') do
      local k, v = string.match(kv, "([a-z]+):([^\t\r\n]+)")
      if k and v then
        fields[k] = v
      end
    end

    local ordinal = tag .. ' ' .. file
    for k, v in pairs(fields) do
      ordinal = ordinal .. ' ' .. k .. ':' .. v
    end

    return {
      valid = true,
      ordinal = ordinal,
      display = make_display,
      scode = scode,
      tag = tag,
      filename = file,
      col = 1,
      lnum = lnum and tonumber(lnum) or 1,
    }
  end
end

return M
