local function onTick(context, dt)
  if context.atWall() then
    context.playSound('hit')
    context.kill()
  end
end

local function onCollide(context, actor)
  if actor.controller == 'coin' or actor.controller == 'projectiles' then
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
