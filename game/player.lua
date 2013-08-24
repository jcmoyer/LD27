local rectangle = require('game.rectangle')

local player = {}
local mt = {__index = player}

function player.new(x, y)
  local instance = {
    x = x,
    y = y,
    w = 32,
    h = 64,
    vx = 0,
    vy = 0,
    hb = rectangle.new(x or 0, y or 0, 32, 64)
  }
  return setmetatable(instance, mt)
end

function player:hitbox()
  local hitbox = self.hb
  hitbox.x = self.x
  hitbox.y = self.y
  return hitbox
end

return player