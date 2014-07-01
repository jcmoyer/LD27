-- Look for modules in lib/ directory
package.path = "./lib/?.lua;" .. package.path

local basicgame = require('hug.basicgame')
local gameloop  = require('hug.gameloop')
local menustate = require('states.menustate')

gameloop.fixint(60)
basicgame.start(menustate.new())