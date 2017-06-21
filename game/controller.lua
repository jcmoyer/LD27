-- abstracts player input such that it can be applied to any actor

local controller = {}
local mt = {__index = controller}

function controller.new(actor)
  local instance = {
    actor = actor
  }
  return setmetatable(instance, mt)
end

function controller:keypressed(key, unicode)
  if key == 'up' then
    self.actor:jump()
  end
end

function controller:keyreleased(key)
end

function controller:update(dt)
  if love.keyboard.isDown('left') then
    self.actor:move('left')
  end
    
  if love.keyboard.isDown('right') then
    self.actor:move('right')
  end
end

return controller
