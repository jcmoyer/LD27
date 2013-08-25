local time = 0
local maxtime = 2

local function onTick(context, dt)
  if context.atWall() or time >= maxtime then
    if context.playerDistance() < 500 then
      context.playSound('hit')
    end
    context.kill()
  end
  
  time = time + dt
end

local function onCollide(context, actor)
  if actor.controller == 'coin' or actor.controller == 'projectiles' or actor.controller == 'heart' then
    return
  end
  
  context.playSound('hit')
  context.kill()
  actor:kill()
end

return {
  onTick = onTick,
  onCollide = onCollide
}
