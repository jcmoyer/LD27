local gamestate = require('core.gamestate')
local playstate = require('states.playstate')
local level = require('game.level')
local camera = require('core.camera')
local fontpool = require('core.fontpool')

local menustate = setmetatable({}, {__index = gamestate})
local mt = {__index = menustate}

local headerfont = fontpool.get(48)

local function drawHeader()
  local text = love.graphics.getCaption()
  local w = headerfont:getWidth(text)
  local h = headerfont:getHeight()
  love.graphics.setColor(255, 255, 255)
  love.graphics.setFont(headerfont)
  love.graphics.print(text, love.graphics.getWidth() / 2 - w / 2, love.graphics.getHeight() / 6 - h / 2)
end

function menustate.new()
  local instance = {
    level = level.new('title'),
    camera = camera.new(love.graphics.getWidth(), love.graphics.getHeight())
  }
  return setmetatable(instance, mt)
end

function menustate:onEnter()
  --self:sm():push(playstate.new())
end

function menustate:draw()
  if self.level.bgimage ~= nil then
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.level.bgimage)
  end
  
  love.graphics.push()
  love.graphics.translate(self.camera.x, self.camera.y)
  self.level:draw(self.camera)
  self.level:drawFringe(self.camera)
  love.graphics.pop()
  
  love.graphics.setColor(0, 0, 0, 128)
  love.graphics.rectangle('fill', 0, 0, 800, 600)
  drawHeader()
end

return menustate