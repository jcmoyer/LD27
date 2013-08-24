local actor = require('game.actor')

local player = setmetatable({}, {__index = actor})
local mt = {__index = player}

function player.new(x, y)
  local instance = actor.new(x, y)
  instance.acceleration = 1
  instance.maxspeed = 15
  return setmetatable(instance, mt)
end

return player