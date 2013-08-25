local frame1 = {0, 0, 64, 32}
local frame2 = {0,32, 64, 32}
local frame3 = {0,64, 64, 32}

return {
  image = 'rocket.png',
  
  animations = {
    any = {
      times = { 0.2, 0.2, 0.2 },
      frames = { frame1, frame2, frame3 }
    }
  }
}
