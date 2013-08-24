local gamestate = require('core.gamestate')

local menustate = setmetatable({}, {__index = gamestate})

return menustate