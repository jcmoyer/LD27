local idle1 = {0, 0, 32, 32}
local idle2 = {32, 0, 32, 32}
local air   = {64, 0, 32, 32}

return {
  image = 'jumper.png',
  
  animations = {
    idle = {
      times =  { 0.2, 0.2 },
      frames = { idle1, idle2 }
    },
    
    air = {
      times = { 10 },
      frames = { air }
    }
  }
}
