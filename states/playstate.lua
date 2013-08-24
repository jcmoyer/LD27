local gamestate = require('core.gamestate')
local level = require('game.level')
local player = require('game.player')
local camera = require('core.camera')
local controller = require('game.controller')

local playstate = setmetatable({}, {__index = gamestate})
local mt = {__index = playstate}

function playstate:changelevel(name)
  self.level  = level.new(name)
  self.player = player.new(self.level.playerspawn.x, self.level.playerspawn.y)
  self.camera:center(self.player.x, self.player.y)
  self.controller = controller.new(self.player)
end

function playstate.new()
  local instance = {
    -- these will be set by playstate:changeLevel
    level      = nil,
    player     = nil,
    controller = nil,
    
    camera = camera.new(love.graphics.getWidth(), love.graphics.getHeight())
  }
  setmetatable(instance, mt)
  
  instance:changelevel('level01.lua')
  
  return instance
end

function playstate:keypressed(key)
  self.controller:keypressed(key)
end

function playstate:keyreleased(key)
  self.controller:keyreleased(key)
end

function playstate:update(dt)
  local player = self.player
  
  -- Apply player input
  self.controller:update(dt)
  
  -- Apply gravitational force to player
  player:applyForce('down', 0.2)
  player:update(self.level)
  
  -- Pan camera to player's position gradually
  self.camera:panCenter(player.x, player.y, dt * 3)
end

function playstate:draw()
  love.graphics.translate(math.floor(self.camera.x), math.floor(self.camera.y))
  self.level:draw(self.camera)
  
  -- draw player
  love.graphics.rectangle('fill', self.player:hitbox():unpack())
end

return playstate