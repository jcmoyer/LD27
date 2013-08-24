local rectangle = {}
local mt = {__index = rectangle}

function rectangle.new(x, y, w, h)
  local instance = {
    x = x,
    y = y,
    w = w,
    h = h
  }
  return setmetatable(instance, mt)
end

function rectangle:right()
  return self.x + self.w
end

function rectangle:bottom()
  return self.y + self.h
end

function rectangle:intersects(r)
  return not (self:bottom() < r.y or
              self.y > r:bottom() or
              self.x > r:right()  or
              self:right() < r.x)
end

function rectangle:unpack()
  return self.x, self.y, self.w, self.h
end

return rectangle