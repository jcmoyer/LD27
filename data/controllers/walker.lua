local playwalk  = false
local direction = 'left'

local function switchDirection()
  if direction == 'left' then
    direction = 'right'
  else
    direction = 'left'
  end
end

return function(context, dt)
  if not playwalk then
    context.playAnimation('walk')
    playwalk = true
  end
  if context.atWall() then
    switchDirection()
  end
  context.move(direction)
end