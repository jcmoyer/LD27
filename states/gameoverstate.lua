local uiscene = require('ui.scene')
local uibutton = require('ui.button')
local gamestate = require('hug.gamestate')
local fontpool = require('game.fontpool')

local gameoverstate = setmetatable({}, {__index = gamestate})
local mt = {__index = gameoverstate}

local gameoverFont = fontpool.get(36)
local gameoverSubFont = fontpool.get(16)

local winMessage = 'You win! Thanks for playing!'
local winMessageWidth = gameoverFont:getWidth(winMessage)
local winMessageHeight = gameoverFont:getHeight()

local winSubmessage = 'Made for LD27 :: https://github.com/jcmoyer'
local winSubmessageWidth = gameoverSubFont:getWidth(winSubmessage)

local loseMessage = 'Game over!'
local loseMessageWidth = gameoverFont:getWidth(loseMessage)
local loseMessageHeight = gameoverFont:getHeight()

local function drawWinMessage()
  local w = love.graphics.getWidth()
  local h = love.graphics.getHeight()
  
  love.graphics.setFont(gameoverFont)
  love.graphics.print(winMessage, w / 2 - winMessageWidth / 2, h / 2 - winMessageHeight / 2)

  love.graphics.setFont(gameoverSubFont)
  love.graphics.print(winSubmessage, w / 2 - winSubmessageWidth / 2, h / 2 - winMessageHeight / 2 + winMessageHeight + 8)
end

local function drawLoseMessage()
  local w = love.graphics.getWidth()
  local h = love.graphics.getHeight()
  
  love.graphics.setFont(gameoverFont)
  love.graphics.print(loseMessage, w / 2 - loseMessageWidth / 2, h / 2 - loseMessageHeight / 2)
  
  love.graphics.setFont(gameoverSubFont)
  love.graphics.print(winSubmessage, w / 2 - winSubmessageWidth / 2, h / 2 - winMessageHeight / 2 + winMessageHeight + 8)
end

-- kind can be 'win' or 'lose'; defaults to 'lose'
function gameoverstate.new(kind)
  local instance = {
    kind = kind or 'lose',
    ui = uiscene.new()
  }
  
  local btnmenu = uibutton.new()
  btnmenu.text = "Main Menu"
  btnmenu.w = 100
  btnmenu.h = 50
  btnmenu.x = love.graphics.getWidth() - btnmenu.w - 32
  btnmenu.y = love.graphics.getHeight() - btnmenu.h - 32
  btnmenu.events.click:add(function()
    instance:sm():pop()
  end)
  instance.ui:addchild(btnmenu)
  
  return setmetatable(instance, mt)
end

function gameoverstate:update(dt)
  self.ui:update(dt)
end

function gameoverstate:draw()
  love.graphics.setBackgroundColor(0, 0, 0)
  love.graphics.clear()
  
  love.graphics.setColor(255, 255, 255)
  
  if self.kind == 'win' then
    drawWinMessage()
  elseif self.kind == 'lose' then
    drawLoseMessage()
  end
  
  self.ui:draw()
end

function gameoverstate:mousepressed(x, y, button)
  self.ui:mousepressed(x, y, button)
end

function gameoverstate:mousereleased(x, y, button)
  self.ui:mousereleased(x, y, button)
end

return gameoverstate
