local idle1 = {0, 0, 32, 32}
local idle2 = {32, 0, 32, 32}

return {
  image = 'heart.png',
  
  animations = {
    idle = {
      times =  { 0.2, 0.2 },
      frames = { idle1, idle2 }
    }
  }
}
