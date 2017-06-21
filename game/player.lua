local actor = require('game.actor')

local player = setmetatable({}, {__index = actor})
local mt = {__index = player}

function player.new(x, y)
  local instance = actor.fromScript('player', x, y)
  return setmetatable(instance, mt)
end

return player
