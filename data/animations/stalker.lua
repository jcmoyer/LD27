local idle1 = {0, 0, 32, 64}
local idle2 = {32, 0, 32, 64}

local walk1 = {0, 0, 32, 64}
local walk2 = {64, 0, 32, 64}
local walk3 = walk1
local walk4 = {96, 0, 32, 64}

return {
  image = 'stalker.png',
  default = 'idle',
  
  animations = {
    idle = {
      times = { 0.2, 0.2 },
      frames = { idle1, idle2 }
    },
    
    walk = {
      times  = { 0.2, 0.2, 0.2, 0.2 },
      frames = { walk1, walk2, walk3, walk4 }
    }
  }
}
