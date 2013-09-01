local time = 0
local maxtime = 1

local function spawnDeathActor(context)
  local x, y, w, h = context.dimensions()
  
  if context.facing() == 'right' then
    x = x - 16
  else
    x = x + 16
  end
  
  context.spawnActor('explosion', x, y - 8)
end

local function onTick(context, dt)
  if context.atWall() or time >= maxtime then
    if context.playerDistance() < 500 then
      context.playSound('hit')
    end
    context.kill()
    spawnDeathActor(context)
  end
  
  time = time + dt
end

local function onCollide(context, actor)
  if actor.controller == 'coin' or actor.controller == 'projectiles' or actor.controller == 'heart' then
    return
  end
  if actor.controller == 'explosion' then
    return
  end
  
  context.playSound('hit')
  context.kill()
  actor:kill()
  
  spawnDeathActor(context)
end

return {
  onTick = onTick,
  onCollide = onCollide
}
