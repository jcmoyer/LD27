local aicontroller = {}
local mt = {__index = aicontroller}

local function safeCall(t, name, ...)
  local f = t[name]
  if f ~= nil then
    f(...)
  end
end

function aicontroller.new(name, actor)
  local controller = love.filesystem.load('data/controllers/' .. name .. '.lua')
  local instance = {
    actor = actor,
    t     = controller()
  }
  return setmetatable(instance, mt)
end

function aicontroller:onTick(context, dt)
  self.t.onTick(context, dt)
end

function aicontroller:onTouch(context)
  safeCall(self.t, 'onTouch', context)
end

return aicontroller