local gamestate = require('core.gamestate')
local playstate = require('states.playstate')

local menustate = setmetatable({}, {__index = gamestate})
local mt = {__index = menustate}

function menustate.new()
  return setmetatable({}, mt)
end

return menustate