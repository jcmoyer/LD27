local sounds = {}

local soundfiles = love.filesystem.getDirectoryItems('data/sounds')

for i = 1, #soundfiles do
  local _, _, name = soundfiles[i]:find('([%a%d_]+)%.ogg$')
  if name then
    sounds[name] = love.audio.newSource('data/sounds/' .. name .. '.ogg', 'static')
  end
end

function sounds.play(name)
  local s = sounds[name]
  if s ~= nil then
    s:stop()
    s:play()
  end
end

return sounds