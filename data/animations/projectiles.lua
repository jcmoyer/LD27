local spark1 = {0, 0, 32, 16}
local spark2 = {32, 0, 32, 16}

local fireball1 = {0, 16, 32, 16}
local fireball2 = {32, 16, 32, 16}

return {
  image = 'projectiles.png',
  
  animations = {
    spark = {
      times = {0.2, 0.2},
      frames = {spark1, spark2}
    },
    
    fireball = {
      times = {0.2, 0.2},
      frames = {fireball1, fireball2}
    }
  }
}
