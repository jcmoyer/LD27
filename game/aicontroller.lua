local scriptcache = require('game.scriptcache')

local aicontroller = {}
local mt = {__index = aicontroller}

function aicontroller:safeCall(name, ...)
  if not self.actor.alive then
    return
  end
  
  local f = self.t[name]
  if f ~= nil then
    f(...)
  end
end

function aicontroller:safeCallDead(name, ...)
  local f = self.t[name]
  if f ~= nil then
    f(...)
  end
end

function aicontroller.new(name, actor)
  local controller = scriptcache.get('data/controllers/' .. name .. '.lua')
  local instance = {
    actor = actor,
    t     = controller()
  }
  return setmetatable(instance, mt)
end

function aicontroller:onTick(context, dt)
  self:safeCall('onTick', context, dt)
end

function aicontroller:onTouch(context)
  self:safeCall('onTouch', context)
end

function aicontroller:onDie(context)
  self:safeCallDead('onDie', context)
end

function aicontroller:onCollide(context, actorB)
  self:safeCall('onCollide', context, actorB)
end

return aicontroller
