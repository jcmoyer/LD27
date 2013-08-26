local coinDropMin = 1
local coinDropMax = 3
local heartDropRate = 0.02

local playwalk  = false
local function onTick(context, dt)
  if not playwalk then
    context.playAnimation('walk')
    playwalk = true
  end
  
  if context.atWall() then
    context.jump()
  end
  
  if context.playerDistance() <= 300 then
    context.move(context.playerDirection())
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
