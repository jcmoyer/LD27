local player = {}
local mt = {__index = player}

function player.new(x, y)
  local instance = {
    x = x or 0,
    y = y or 0
  }
  return setmetatable(instance, mt)
end

return player