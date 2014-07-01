local stringex = require('hug.extensions.string')

local path = {}

function path.resolve(filename)
  local parts = stringex.split(filename, '[\\/]+', true)
  local resolved = {}
  
  for i=1,#parts do
    local part = parts[i]
    if part == '..' then
      table.remove(resolved, #resolved)
    else
      resolved[#resolved + 1] = part
    end
  end
  return table.concat(resolved, '/')
end


return path