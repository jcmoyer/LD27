return function(context, dt)
  if context.playerDistance() < 500 then
    context.move(context.playerDirection())
    context.jump()
    
    context.playAnimation('air')
  end
end