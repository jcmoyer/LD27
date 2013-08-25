local animation = require('game.animation')

local animationset = {}
local mt = {__index = animationset}

function animationset.new(name)
  local chunk = love.filesystem.load('data/animations/' .. name .. '.lua')
  local t     = chunk()
  
  local image = love.graphics.newImage('data/images/' .. t.image)
  local animations = {}
  
  for k,v in pairs(t.animations) do
    animations[k] = animation.new(image, v.times, v.frames)
  end
  
  -- get the first animation name
  local first
  for k,v in pairs(t.animations) do
    first = k
    break
  end
  
  local instance = {
    image = image,
    animations = animations,
    current = first 
  }
  
  return setmetatable(instance, mt)
end

function animationset:play(name)
  if self.animations[name] ~= nil then
    self.current = name
  end
  self.animations[self.current]:reset()
end

function animationset:update(dt)
  self.animations[self.current]:update(dt)
end

function animationset:currentQuad()
  return self.animations[self.current]:currentQuad()
end

return animationset