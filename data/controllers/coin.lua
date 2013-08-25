local jumped = false

local function onTouch(context)
  context.playSound('coin')
  context.giveCoins(1)
  context.giveTime(1)
  context.kill()
end

local function onTick(context, dt)
  if not jumped then
    context.applyVectorForce(math.random() * 8 - 4, math.random() * -7)
    jumped = true
  end
  context.move(direction)
end

return {
  onTouch = onTouch,
  onTick = onTick
}
