local animation = require('game.animation')
local scriptcache = require('game.scriptcache')
local imagecache = require('game.imagecache')

local animationset = {}
local mt = {__index = animationset}

function animationset.new(name)
  local chunk = scriptcache:get('data/animations/' .. name .. '.lua')
  local t     = chunk()
  
  local image = imagecache:get('data/images/' .. t.image)
  local animations = {}
  
  for k,v in pairs(t.animations) do
    animations[k] = animation.new(image, v.times, v.frames)
  end
  
  local which = t.default
  -- pick a random (hash table doesn't guarantee order) animation
  if which == nil then
    for k,v in pairs(t.animations) do
      which = k
      break
    end
  end
  
  local instance = {
    image = image,
    animations = animations,
    current = which 
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
