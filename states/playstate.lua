local gamestate = require('core.gamestate')

local playstate = setmetatable({}, {__index = gamestate})
local mt = {__index = playstate}

function playstate.new()
  return setmetatable({}, mt)
end

return playstate