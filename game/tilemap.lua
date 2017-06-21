local tilemap = {}
local mt = {__index = tilemap}

function tilemap.new(data, width, height)
  local instance = {
    data = data,
    width = width,
    height = height
  }
  return setmetatable(instance, mt)
end

function tilemap:at(x, y)
  return self.data[(y - 1) * self.width + x] or 0
end

return tilemap
