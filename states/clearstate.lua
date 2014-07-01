local gamestate = require('hug.gamestate')
local fontpool = require('game.fontpool')
local timerpool = require('hug.timerpool')
local mathex = require('hug.extensions.math')
local sounds = require('game.sounds')

local clearstate = setmetatable({}, {__index = gamestate})
local mt = {__index = clearstate}

local headerFont = fontpool.get(36)

function clearstate.isclearstate(t)
  return getmetatable(t) == mt
end

function clearstate.new(areaname, nextlevel)
  local instance = {
    areaname = areaname,
    nextlevel = nextlevel,
    transparent = true,
    text = string.format('You cleared %s!', areaname),
    fader = nil,
    timerpool = timerpool.new()
  }
  return setmetatable(instance, mt)
end

function clearstate:enter()
  local instance = self
  self.fader = self.timerpool:start(1, function()
    self.timerpool:start(5, function()
      instance:sm():pop()
    end)
  end)
  sounds.play('fanfare')
end

function clearstate:update(dt)
  self.timerpool:update(dt)
end

function clearstate:draw()
  local a = mathex.clamp((1 - (self.fader:remaining() / self.fader:duration())) * 255, 0, 255)
  
  love.graphics.setColor(0, 0, 0, a)
  love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  
  local tw = headerFont:getWidth(self.text)
  local th = headerFont:getHeight()
  
  if self.fader:status() == 'finished' then
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(headerFont)
    love.graphics.print(self.text, love.graphics.getWidth() / 2 - tw / 2, love.graphics.getHeight() / 2 - th / 2)
  end
end

return clearstate