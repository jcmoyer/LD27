local idle = {0, 0, 32, 32}

local walk1 = {0, 0, 32, 32}
local walk2 = {32, 0, 32, 32}
local walk3 = {64, 0, 32, 32}
local walk4 = {96, 0, 32, 32}

return {
  image = 'walker.png',
  
  animations = {
    idle = {
      times = { 0.2 },
      frames = { idle }
    },
    
    walk = {
      times  = { 0.15, 0.15, 0.2, 0.2 },
      frames = { walk1, walk2, walk3, walk4 }
    }
  }
}
