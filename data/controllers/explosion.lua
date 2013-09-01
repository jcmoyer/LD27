local life = 5

local function onTick(context, dt)
  life = life - dt
  if life <= 0 then
    context.kill()
  end
end

return {
  onTick = onTick
}
