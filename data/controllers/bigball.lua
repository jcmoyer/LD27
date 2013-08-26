local coinDropMin = 0
local coinDropMax = 2
local heartDropRate = 0.08

local function onTick(context, dt)
  if context.playerDistance() < 500 then
    context.move(context.playerDirection())
    
    if context.onGround() then
      context.playSound('earthshake')
      context.shakeCamera(1, 15)
    end
    
    if context.jump() then
      context.playSound('jump')
    end
  end
end

local function onDie(context)
  local x, y, w, h = context.dimensions()
  local n = math.random(coinDropMin, coinDropMax)
  for i = 1, n do
    context.spawnActor('coin', x + w / 2, y + h / 2)
  end
  if math.random() <= heartDropRate then
    context.spawnActor('heart', x + w / 2, y + h / 2)
  end
end

return {
  onTick = onTick,
  onDie  = onDie
}
