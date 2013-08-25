local function onTick(context, dt)
  if context.atWall() then
    context.kill()
  end
end

local function onCollide(context, actor)
  context.kill()
  actor:kill()
end

return {
  onTick = onTick,
  onCollide = onCollide
}
