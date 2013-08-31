local vector2 = {}
local mt = {__index = vector2}

local function checkvec2(v)
  return getmetatable(v) == mt
end

function mt.__add(a, b)
  local result = a:clone()
  result:add(b)
  return result
end

function mt.__sub(a, b)
  local result = a:clone()
  result:sub(b)
  return result
end

function mt.__mul(a, b)
  local result
  if checkvec2(a) then
    result = a:clone()
    result:mul(b)
  else
    result = b:clone()
    result:mul(a)
  end
  return result
end

function mt.__div(a, b)
  local result
  if checkvec2(a) then
    result = a:clone()
    result:div(b)
  else
    result = b:clone()
    result:div(a)
  end
  return result
end

function vector2.new(x, y)
  local instance = {
    x or 0,
    y or 0
  }
  return setmetatable(instance, mt)
end

function vector2:clone()
  return setmetatable({self[1], self[2]}, mt)
end

function vector2:x()
  return self[1]
end

function vector2:y()
  return self[2]
end

-- possible values:
--    a as vector2
--    a and b as numbers
function vector2:add(a, b)
  if checkvec2(a) then
    self[1] = self[1] + a[1]
    self[2] = self[2] + a[2]
  else
    self[1] = self[1] + a
    self[2] = self[2] + b
  end
end

function vector2:sub(a, b)
  if checkvec2(a) then
    self[1] = self[1] - a[1]
    self[2] = self[2] - a[2]
  else
    self[1] = self[1] - a
    self[2] = self[2] - b
  end
end

function vector2:mul(a)
  self[1] = self[1] * a
  self[2] = self[2] * a
end

function vector2:div(a)
  self[1] = self[1] * a
  self[2] = self[2] * a
end

function vector2:normalize()
  local x = self[1]
  local y = self[2]
  local l = math.sqrt(x * x + y * y)
  self[1] = x / l
  self[2] = y / l
end

function vector2:set(x, y)
  self[1] = x
  self[2] = y
end

function vector2:zero()
  self[1] = 0
  self[2] = 0
end

return vector2