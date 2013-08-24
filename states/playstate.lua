local gamestate = require('core.gamestate')

local playstate = setmetatable({}, {__index = gamestate})

return playstate