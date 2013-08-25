local gamestate = require('core.gamestate')
local level = require('game.level')
local player = require('game.player')
local camera = require('core.camera')
local controller = require('game.controller')
local mathex = require('core.extensions.math')
local fontpool = require('core.fontpool')
local aicontroller = require('game.aicontroller')
local actorcontext = require('game.actorcontext')
local gameoverstate = require('states.gameoverstate')

local playstate = setmetatable({}, {__index = gamestate})
local mt = {__index = playstate}

local lifeFont = fontpool.get(18)
local lifeHudH = lifeFont:getHeight()

local function lifetimeStr(x)
  local sec  = x
  local msec = 1000 * (x - math.floor(x))
  return string.format('%02d:%03d', sec, msec)
end

function playstate:changelevel(name)
  self.level  = level.new(name)
  self.player = player.new(self.level.playerspawn.x, self.level.playerspawn.y)
  
  -- build ai controllers
  self.ais    = {}
  for i = 1, #self.level.actors do
    local ai      = aicontroller.new(self.level.actors[i].controller, self.level.actors[i])
    local context = actorcontext.new(self.level.actors[i], self.player)
    --self.ais[#self.ais + 1] = ai
    self.ais[#self.ais + 1] = function(dt)
      ai:update(context, dt)
    end
  end
  
  self.camera:center(self.player.x, self.player.y)
  self.controller = controller.new(self.player)
end

function playstate.new()
  local instance = {
    -- these will be set by playstate:changeLevel
    level      = nil,
    player     = nil,
    controller = nil,
    ais        = nil,
    
    lives      = 3,
    lifetime   = 10,
    
    camera = camera.new(love.graphics.getWidth(), love.graphics.getHeight())
  }
  setmetatable(instance, mt)
  
  instance:changelevel('level01.lua')
  
  return instance
end

function playstate:keypressed(key)
  local intercept = false
  
  if key == 'up' then
    local portal = self.level:portalAt(self.player:hitbox():center())
    if portal ~= nil then
      self:changelevel(portal.destination)
      intercept = true
    end
  end
  
  if intercept == false then
    self.controller:keypressed(key)
  end
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
  
  for i = 1, #self.ais do
    self.ais[i](dt)
  end
  for i = 1, #self.level.actors do
    -- Gravity
    self.level.actors[i]:applyForce('down', 0.2)
    self.level.actors[i]:update(self.level, dt)
  end
  
  -- Pan camera to player's position gradually
  self.camera:panCenter(player.x, player.y, dt * 3)
  
  -- Lock camera to level boundaries
  self.camera.x = mathex.clamp(self.camera.x, -self.level.width  * self.level.tilewidth  + love.graphics.getWidth(), 0)
  self.camera.y = mathex.clamp(self.camera.y, -self.level.height * self.level.tileheight + love.graphics.getHeight(), 0)
  
  self.lifetime = self.lifetime - dt
  
  if self.lifetime <= 0 then
    self.lives    = self.lives - 1
    self.lifetime = 10
    
    if self.lives <= 0 then
      self:sm():pop()
      self:sm():push(gameoverstate.new())
    end
  end
end

function playstate:draw()
  love.graphics.push()
  
  love.graphics.translate(math.floor(self.camera.x), math.floor(self.camera.y))
  self.level:draw(self.camera)
  
  -- draw player
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle('fill', self.player:hitbox():unpack())
  
  for i = 1, #self.level.actors do
    local actor = self.level.actors[i]
    local x, y = actor:hitbox():unpack()
    love.graphics.drawq(actor.aset.image, actor.aset:currentQuad(), x, y)
  end
  
  love.graphics.pop()
  
  love.graphics.setColor(0, 0, 0, 128)
  love.graphics.rectangle('fill', love.graphics.getWidth() - 145, 0, 145, lifeHudH)
  
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(lifeFont)
  love.graphics.print(string.format('%05d', self.lives), love.graphics.getWidth() - 140, 0)
  love.graphics.print(lifetimeStr(self.lifetime), love.graphics.getWidth() - 65, 0)
end

return playstate