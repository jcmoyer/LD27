local playwalk  = false
return function(context, dt)
  if not playwalk then
    context.playAnimation('walk')
    playwalk = true
  end
  
  if context.playerDistance() <= 300 then
    context.move(context.playerDirection())
  end
end