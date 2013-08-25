local sounds = require('game.sounds')

-- provides an interface between the world and aicontroller
local actorcontext = {}

function actorcontext.new(actor, player)
  local t = {}
  function t.move(direction)
    return actor:move(direction)
  end
  function t.applyForce(direction, magnitude)
    return actor:applyForce(direction, magnitude)
  end
  function t.jump()
    return actor:jump()
  end
  function t.playerDistance()
    local ax, ay = actor:hitbox():center()
    local px, py = player:hitbox():center()
    local dx = px - ax
    local dy = py - ay
    return math.sqrt(dx * dx + dy * dy)
  end
  function t.playerDirection()
    local ax = actor:hitbox():center()
    local px = player:hitbox():center()
    if ax <= px then
      return 'right'
    else
      return 'left'
    end
  end
  function t.playAnimation(name)
    return actor.aset:play(name)
  end
  function t.atWall()
    return actor.atwall
  end
  function t.onGround()
    return actor.onground
  end
  function t.playSound(name)
    return sounds.play(name)
  end
  return t
end

return actorcontext