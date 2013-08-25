local walkonce = false

return function(context, dt)
  if not walkonce then
    context.playAnimation('walk')
    walkonce = true
  end
  context.move(context.playerDirection())
end