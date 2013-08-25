local coinDropMin = 5
local coinDropMax = 15
local heartDropMin = 2
local heartDropMax = 4

local function onTick(context, dt)
  if context.playerDistance() < 500 then
    context.move(context.playerDirection())
    context.jump()
    
    context.playAnimation('air')
  end
end

local function onDie(context)
  local x, y, w, h = context.dimensions()
  local n = math.random(coinDropMin, coinDropMax)
  for i = 1, n do
    context.spawnActor('coin', x + w / 2, y + h / 2)
  end
  n = math.random(heartDropMin, heartDropMax)
  for i = 1, n do
    context.spawnActor('heart', x + w / 2, y + h / 2)
  end
end

return {
  onTick = onTick,
  onDie  = onDie
}
