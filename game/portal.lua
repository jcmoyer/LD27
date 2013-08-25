local rectangle = require('game.rectangle')

local portal = {}
local mt = {__index = portal}

function portal.new(x, y, destination, wins)
  local instance = {
    x = x,
    y = y,
    destination = destination,
    hb = rectangle.new(x, y, 64, 96),
    wins = wins
  }
  return setmetatable(instance, mt)
end

function portal:hitbox()
  local hitbox = self.hb
  hitbox.x = self.x
  hitbox.y = self.y
  return hitbox
end

return portal