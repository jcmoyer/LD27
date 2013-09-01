local frame1 = {0, 0, 32, 32}
local frame2 = {32, 0, 32, 32}
local frame3 = {64, 0, 32, 32}
local frame4 = {96, 0, 32, 32}
local frame5 = {0, 0, 1, 1}

return {
  image = 'explode.png',
  
  animations = {
    idle = {      
      times =  { 0.1, 0.1, 0.1, 0.1, 100 },
      frames = { frame3, frame2, frame4, frame1, frame5 }
    }
  }
}
