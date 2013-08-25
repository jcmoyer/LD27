local aicontroller = {}
local mt = {__index = aicontroller}

function aicontroller.new(name, actor)
  local controller = love.filesystem.load('data/controllers/' .. name .. '.lua')
  local instance = {
    actor = actor,
    f     = controller()
  }
  return setmetatable(instance, mt)
end

-- receives an actorcontext and dt
function aicontroller:update(context, dt)
  self.f(context, dt)
end

return aicontroller