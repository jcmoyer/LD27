local gamestate = require('hug.gamestate')
local playstate = require('states.playstate')
local level = require('game.level')
local chasecamera = require('hug.chasecamera')
local fontpool = require('hug.fontpool')

local uiscene = require('ui.scene')
local uistackpanel = require('ui.stackpanel')
local uibutton = require('ui.button')

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
    camera = chasecamera.new(love.graphics.getWidth(), love.graphics.getHeight())
  }
  setmetatable(instance, mt)
  
  -- ui code
  local ui = uiscene.new()
  local stackpanel = uistackpanel.new()
  stackpanel.x = love.graphics.getWidth() / 2 - 75
  stackpanel.y = love.graphics.getHeight() / 2 - 50
  stackpanel.w = 150
  stackpanel.h = 100
  local btnstart = uibutton.new()
  btnstart.text = "Start"
  btnstart.events.click:add(function()    
    instance:sm():push(playstate.new())
  end)
  local btnexit = uibutton.new()
  btnexit.text = "Exit"
  btnexit.events.click:add(function()
    love.event.quit()
  end)
  stackpanel:addchild(btnstart)
  stackpanel:addchild(btnexit)
  ui:addchild(stackpanel)
  instance.ui = ui
  -- end ui code
  
  return instance
end

function menustate:mousepressed(x, y, button)
  self.ui:mousepressed(x, y, button)
end

function menustate:mousereleased(x, y, button)
  self.ui:mousereleased(x, y, button)
end

function menustate:update(dt)
  self.ui:update(dt)
end

function menustate:draw(a)
  if self.level.bgimage ~= nil then
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.level.bgimage)
  end
  
  love.graphics.push()
  self.level:draw(self.camera, 0, 0)
  self.level:drawFringe(self.camera, 0, 0)
  love.graphics.pop()
  
  love.graphics.setColor(0, 0, 0, 128)
  love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  drawHeader()
  
  self.ui:draw()
end

return menustate