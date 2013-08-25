local frame1 = {0, 0, 16, 16}
local frame2 = {32, 0, 16, 16}
local frame3 = {16, 0, 16, 16}
local frame4 = {48, 0, 16, 16}

return {
  image = 'coin.png',
  
  animations = {
    idle = {
      times =  { 0.2, 0.2, 0.2, 0.2 },
      frames = { frame1, frame2, frame3, frame4 }
    }
  }
}
