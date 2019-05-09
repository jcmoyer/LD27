-- Look for modules in lib/ directory
package.path = "./lib/?.lua;" .. package.path

local setColor = love.graphics.setColor
love.graphics.setColor = function(r, g, b, a)
  if type(r) == 'table' then
    love.graphics.setColor(unpack(r))
  else
    setColor(r / 255, g / 255, b / 255, (a or 255) / 255)
  end
end

local basicgame = require('hug.basicgame')
local gameloop  = require('hug.gameloop')
local menustate = require('states.menustate')

gameloop.fixint(60)
basicgame.start(menustate.new())
