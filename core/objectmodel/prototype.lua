local prototype = {}

-- returns true if 'm' is an __index of the metatable of 't'; otherwise false
function prototype.indexes(m, t)
  local mt = getmetatable(t)
  if type(mt) == 'table' then
    if m == mt then
      return true
    elseif type(mt.__index) == 'table' then
      return prototype.indexes(mt.__index, t)
    end
  end
  return false
end

return prototype