local gamestate = require('hug.gamestate')
local level = require('game.level')
local player = require('game.player')
local camera = require('hug.camera')
local chasecamera = require('hug.chasecamera')
local controller = require('game.controller')
local mathex = require('hug.extensions.math')
local fontpool = require('hug.fontpool')
local aicontroller = require('game.aicontroller')
local actorcontext = require('game.actorcontext')
local gameoverstate = require('states.gameoverstate')
local clearstate = require('states.clearstate')
local sounds = require('game.sounds')
local stats = require('game.stats')
local vector2 = require('hug.vector2')

local playstate = setmetatable({}, {__index = gamestate})
local mt = {__index = playstate}

local lifeFont = fontpool.get(18)
local lifeHudH = lifeFont:getHeight()

local hudLife = love.graphics.newImage('data/images/hudlife.png')
local hudCoin = love.graphics.newImage('data/images/hudcoin.png')
local hudClock = love.graphics.newImage('data/images/hudclock.png')

local function lifetimeStr(x)
  local sec  = x
  local msec = 1000 * (x - math.floor(x))
  return string.format('%02d:%03d', math.floor(sec), math.floor(msec))
end

function playstate:spawnActor(kind, x, y)
  local a = self.level:spawnActor(kind, x, y)
  
  local ai      = aicontroller.new(a.controller, a)
  -- whoa this is ugly
  local instance = self
  local context = actorcontext.new(a, self.player, function(...) return instance:spawnActor(...) end, self.stats, self.camera)
  --self.ais[#self.ais + 1] = ai
  self.ais[#self.ais + 1] = {
    onTick = function(dt)
      ai:onTick(context, dt)
    end,
    onTouch = function()
      ai:onTouch(context)
    end,
    onDie = function()
      ai:onDie(context)
    end,
    onCollide = function(actorB)
      ai:onCollide(context, actorB)
    end
  }
  self.actorais[a] = self.ais[#self.ais]
  
  return a, ai
end

function playstate:killPlayer()
  sounds.play('death')
  
  self.stats:deductLife()
  
  if self.stats.lives <= 0 then
    self:sm():pop()
    self:sm():push(gameoverstate.new())
  end
  
  local respawnArea = self.level:lastRespawn(self.player.x, self.player.y)
  local resx, resy  = respawnArea:center()
  self.player.x = resx - self.player.w / 2
  self.player.y = resy - self.player.h / 2
end

function playstate:changelevel(name)
  self.level  = level.new(name)
  self.player = player.new(self.level.playerspawn.x, self.level.playerspawn.y)
  
  -- build ai controllers
  self.ais      = {}
  self.actorais = {}
  for i = 1, #self.level.actors do
    local ai      = aicontroller.new(self.level.actors[i].controller, self.level.actors[i])
    -- whoa this is ugly
    local instance = self
    local context = actorcontext.new(self.level.actors[i], self.player, function(...) return instance:spawnActor(...) end, self.stats, self.camera)
    --self.ais[#self.ais + 1] = ai
    self.ais[#self.ais + 1] = {
      onTick = function(dt)
        ai:onTick(context, dt)
      end,
      onTouch = function()
        ai:onTouch(context)
      end,
      onDie = function()
        ai:onDie(context)
      end,
      onCollide = function(actorB)
        ai:onCollide(context, actorB)
      end
    }
    self.actorais[self.level.actors[i]] = self.ais[#self.ais]
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
    actorais   = nil,
    
    stats = stats.new(),
    
    camera = chasecamera.new(love.graphics.getWidth(), love.graphics.getHeight(), 30, 1, 10),
    
    lastdt = 0
  }
  setmetatable(instance, mt)
  
  instance:changelevel('level01')
  
  return instance
end

function playstate:onEnter(oldstate)
  if clearstate.isclearstate(oldstate) then
    self:changelevel(oldstate.nextlevel)
  end
end

function playstate:keypressed(key)
  local intercept = false
  
  if key == 'up' then
    local portal = self.level:portalAt(self.player:hitbox():center())
    if portal ~= nil then
      if portal.wins then
        self:sm():pop()
        self:sm():push(gameoverstate.new('win'))
      else
        self:sm():push(clearstate.new(self.level.areaname, portal.destination))
      end
      intercept = true
    end
  end
  
  if key == 'z' then
    local x, y = self.player:hitbox():center()
    local a, c = self:spawnActor('projectiles', x, y)
    
    sounds.play('projectile')
    a.facing = self.player.facing
    a:applyForce(self.player.facing, 9)
    
    intercept = true
  end
  
  if intercept == false then
    self.controller:keypressed(key)
  end
end

function playstate:keyreleased(key)
  self.controller:keyreleased(key)
end

function playstate:update(dt)
  -- Ideally this shouldn't be stored, but it's needed to predict camera motion
  -- in the render step. Maybe add a way to get the update rate?
  self.lastdt = dt
  
  local player = self.player

  -- Apply player input
  self.controller:update(dt)
  
  -- Apply gravitational force to player
  player:applyForce('down', 0.2)
  player:update(self.level, dt)
  
  local playerHitbox = player:hitbox()
  
  for i = 1, #self.ais do
    self.ais[i].onTick(dt)
  end
  for i = #self.level.actors, 1, -1 do
    local actor = self.level.actors[i]
    
    if not actor.playeronly then
      for j = i - 1, 1, -1 do
        local actorB = self.level.actors[j]
        if actor:hitbox():intersects(actorB:hitbox()) then
          self.actorais[self.level.actors[i]].onCollide(actorB)
        end
      end
    end
    
    -- Gravity
    if actor.ignoregravity == false then
      actor:applyForce('down', 0.2)
    end
    actor:update(self.level, dt)
    
    if actor.alive then
      if actor:hitbox():intersects(playerHitbox) then
        self.actorais[self.level.actors[i]].onTouch()
        if actor.lethal == true then
          self:killPlayer()
        end
      end
    else
      self.actorais[self.level.actors[i]].onDie()
      self.actorais[self.level.actors[i]] = nil
      table.remove(self.level.actors, i)
    end
  end
  
  -- Pan camera to player's position gradually
  self.camera:update(self.lastdt, vector2.new(player:hitbox():center()))
  self.camera:clamp(0, 0, self.level.width * self.level.tilewidth, self.level.height * self.level.tileheight)
  
  self.stats:update(dt)
  self.stats:cap()
  
  if self.stats:lifeEnded() then
    self:killPlayer()
  end
  
  -- kill the player if he falls to 120% of the map's height
  if self.player.y > self.level.height * self.level.tileheight * 1.2 then
    self:killPlayer()
  end
end

function playstate:draw(a)
  local px, py = self.player:predict(a)

  local rx, ry = self.camera:predict(self.lastdt, vector2.new(self.player:hitbox():center()), a)
  
  -- Calculate the left and top sides of the camera
  rx = rx - self.camera.width / 2
  ry = ry - self.camera.height / 2

  if self.level.bgimage ~= nil then
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.level.bgimage)
  end
  
  love.graphics.push()
  
  love.graphics.translate(math.floor(-rx), math.floor(-ry))
  self.level:draw(self.camera, rx, ry)

  -- draw player
  love.graphics.setColor(255, 255, 255)
  local x, y = self.player:hitbox():unpack()
  
  local hw = self.player.w / 2
  
  love.graphics.drawq(self.player.aset.image, self.player.aset:currentQuad(), math.floor(px) + hw, math.floor(py), 0, self.player:facingScaleX(), 1, hw)
  
  -- draw actors
  for i = 1, #self.level.actors do
    local actor = self.level.actors[i]
    local x, y = actor:predict(a)
    local hw = actor.w / 2
    love.graphics.drawq(actor.aset.image, actor.aset:currentQuad(), math.floor(x) + hw, math.floor(y), 0, actor:facingScaleX(), 1, hw)
  end
  
  self.level:drawFringe(self.camera, rx, ry)
  
  love.graphics.pop()
  
  love.graphics.setColor(0, 0, 0, 128)
  love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), lifeHudH)
  
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(lifeFont)
  
  love.graphics.draw(hudCoin, 4, 2)
  love.graphics.draw(hudLife, love.graphics.getWidth() - 140 - 16, 2)
  love.graphics.draw(hudClock, love.graphics.getWidth() - 65 - 16, 2)
  
  love.graphics.print(self.stats.coins, 24, 0)
  love.graphics.print(string.format('%05d', self.stats.lives), love.graphics.getWidth() - 140, 0)
  love.graphics.print(lifetimeStr(self.stats.lifetime), love.graphics.getWidth() - 65, 0)
end

return playstate