local rectangle = require('game.rectangle')
local mathex = require('core.extensions.math')

local actor = {}
local mt = {__index = actor}

function actor.new(x, y)
  local instance = {
    x = x,
    y = y,
    w = 32,
    h = 64,
    vx = 0,
    vy = 0,
    
    maxspeed     = 5,
    acceleration = 1,
    damping      = 0.8,
    jumpvel      = -7,
    onground     = false,
    
    hb = rectangle.new(x or 0, y or 0, 32, 64)
  }
  return setmetatable(instance, mt)
end

function actor.fromScript(name, x, y)
  local chunk = love.filesystem.load('data/actors/' .. name .. '.lua')
  local t     = chunk()
  
  local instance        = actor.new(x, y)
  instance.maxspeed     = t.maxspeed or instance.maxspeed
  instance.acceleration = t.acceleration or instance.acceleration
  instance.damping      = t.damping or instance.damping
  instance.jumpvel      = t.jumpvel or instance.jumpvel
  
  return instance
end

function actor:hitbox()
  local hitbox = self.hb
  hitbox.x = self.x
  hitbox.y = self.y
  return hitbox
end

function actor:move(direction)
  if direction == 'left' then
    self.vx = self.vx - self.acceleration
  elseif direction == 'right' then
    self.vx = self.vx + self.acceleration
  end
  self.vx = mathex.clamp(self.vx, -self.maxspeed, self.maxspeed)
end

function actor:applyForce(direction, magnitude)
  if direction == 'left' then
    self.vx = self.vx - magnitude
  elseif direction == 'right' then
    self.vx = self.vx + magnitude
  elseif direction == 'up' then
    self.vy = self.vy - magnitude
  elseif direction == 'down' then
    self.vy = self.vy + magnitude
  end
end

function actor:jump()
  if self.onground == true then
    self.onground = false
    self.vy = self.jumpvel
    return true
  else
    return false
  end
end

-- takes the level to resolve collision within
function actor:update(level)
  self.x = self.x + self.vx
  local hitbox = self:hitbox()
  
  -- X axis
  -- we have to fudge the numbers a bit; if we don't subtract 1 from the bottom weird things happen
  for y = hitbox.y, hitbox:bottom() - 1 do
    local solid, tx = level:solidAt(hitbox.x, y)
    if solid then
      self.x = tx
      self.vx = 0
    end
    
    solid, tx = level:solidAt(hitbox:right(), y)
    if solid then
      self.x = tx - self.w - level.tilewidth
      self.vx = 0
    end
  end
  
  self.y = self.y + self.vy
  hitbox = self:hitbox()
  
  -- Y axis
  -- same as above
  for x = hitbox.x, hitbox:right() - 1 do
    local solid, _, ty = level:solidAt(x, hitbox:bottom())
    if solid then
      self.y = ty - self.h
      self.vy = 0
      self.onground = true
    end
    
    solid, _, ty = level:solidAt(x, hitbox.y)
    if solid then
      self.y = ty + level.tileheight
      self.vy = 0
    end
  end
  
  -- apply damping
  self.vx = self.vx * self.damping
end

return actor