local rectangle = require('hug.rectangle')
local mathex = require('hug.extensions.math')
local animationset = require('game.animationset')
local scriptcache = require('game.scriptcache')

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
    
    ignoregravity      = false,
    ignoreworld        = false,
    maxspeed           = 5,
    airacceleration    = 1,
    groundacceleration = 1,
    damping            = 0.8,
    jumpvel            = -7,
    onground           = false,
    atwall             = false,
    
    -- only used for scripted actors
    controller = nil,
    
    -- animation set
    aset = nil,
    
    lethal = false,
    alive  = true,
    
    facing = 'right',
    playeronly = false,
    
    hb = rectangle.new(x or 0, y or 0, 32, 64)
  }
  return setmetatable(instance, mt)
end

function actor.fromScript(name, x, y)
  local chunk = scriptcache.get('data/actors/' .. name .. '.lua')
  local t     = chunk()
  
  local instance              = actor.new(x, y)
  instance.ignoregravity      = t.ignoregravity or instance.ignoregravity
  instance.ignoreworld        = t.ignoreworld or instance.ignoreworld
  instance.maxspeed           = t.maxspeed or instance.maxspeed
  instance.airacceleration    = t.airacceleration or instance.airacceleration
  instance.groundacceleration = t.groundacceleration or instance.groundacceleration
  instance.damping            = t.damping or instance.damping
  instance.jumpvel            = t.jumpvel or instance.jumpvel
  
  if t.hitbox then
    instance.hb = rectangle.new(unpack(t.hitbox))
    instance.w  = instance.hb:width()
    instance.h  = instance.hb:height()
  end
  
  instance.controller = t.controller
  instance.aset       = animationset.new(t.animation)
  
  instance.lethal = t.lethal or instance.lethal
  instance.playeronly = t.playeronly or instance.playeronly
  
  return instance
end

function actor:facingScaleX()
  if self.facing == 'right' then
    return -1
  else
    return 1
  end
end

function actor:hitbox()
  local hitbox = self.hb
  hitbox[1] = self.x
  hitbox[2] = self.y
  return hitbox
end

function actor:move(direction)
  local acceleration
  if self.onground then
    acceleration = self.groundacceleration
  else
    acceleration = self.airacceleration
  end
  if direction == 'left' then
    self.vx = self.vx - acceleration
  elseif direction == 'right' then
    self.vx = self.vx + acceleration
  end
  self.vx = mathex.clamp(self.vx, -self.maxspeed, self.maxspeed)
  
  if self.vx < 0 then
    self.facing = 'left'
  else
    self.facing = 'right'
  end
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

function actor:applyVectorForce(vx, vy)
  self.vx = self.vx + vx
  self.vy = self.vy + vy
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

function actor:collideX(level)
  self.atwall = false
  
  self.x = self.x + self.vx
  local hitbox = self:hitbox()
  
  -- X axis
  -- we have to fudge the numbers a bit; if we don't subtract 1 from the bottom weird things happen
  for y = hitbox:y(), hitbox:bottom() - 1 do
    local solid, tx = level:solidAt(hitbox:x(), y)
    if solid then
      self.x = tx
      self.vx = 0
      self.atwall = true
    end
    
    solid, tx = level:solidAt(hitbox:right(), y)
    if solid then
      self.x = tx - self.w - level.tilewidth
      self.vx = 0
      self.atwall = true
    end
  end
end

function actor:collideY(level)
  self.y = self.y + self.vy
  local hitbox = self:hitbox()
  
  -- Y axis
  -- same as above
  for x = hitbox:x(), hitbox:right() - 1 do
    local solid, _, ty = level:solidAt(x, hitbox:bottom())
    if solid then
      self.y = ty - self.h
      self.vy = 0
      self.onground = true
    end
    
    solid, _, ty = level:solidAt(x, hitbox:y())
    if solid then
      self.y = ty + level.tileheight
      self.vy = 0
    end
  end
end

-- takes the level to resolve collision within
function actor:update(level, dt)
  self.atwall = false
  
  if not self.ignoreworld then
    self:collideX(level)
    self:collideY(level)
  end
  
  -- apply damping
  self.vx = self.vx * self.damping
  
  -- animate
  if self.aset ~= nil then
    self.aset:update(dt)
  end
end

function actor:kill()
  self.alive = false
end

function actor:predict(a)
  return mathex.lerp(self.x, self.x + self.vx, a), mathex.lerp(self.y, self.y + self.vy, a)
end

return actor
