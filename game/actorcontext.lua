local sounds = require('game.sounds')

-- provides an interface between the world and aicontroller
local actorcontext = {}

function actorcontext.new(actor, player, spawner, stats)
  local t = {}
  function t.move(direction)
    return actor:move(direction)
  end
  function t.applyForce(direction, magnitude)
    return actor:applyForce(direction, magnitude)
  end
  function t.applyVectorForce(vx, vy)
    return actor:applyVectorForce(vx, vy)
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
    return actor.alive and actor.atwall
  end
  function t.onGround()
    return actor.alive and actor.onground
  end
  function t.playSound(name)
    return sounds.play(name)
  end
  function t.kill()
    return actor:kill()
  end
  function t.dimensions()
    return actor:hitbox():unpack()
  end
  function t.spawnActor(kind, x, y)
    return spawner(kind, x, y)
  end
  function t.giveLives(n)
    stats.lives = stats.lives + n
  end
  function t.giveTime(n)
    stats.lifetime = stats.lifetime + n
  end
  function t.giveCoins(n)
    stats.coins = stats.coins + n
  end
  return t
end

return actorcontext