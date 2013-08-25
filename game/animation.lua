local animation = {}
local mt = {__index = animation}

function animation.new(image, times, quads)
  assert(#times == #quads, 'times and quads must have an equal number of elements')
  
  local imw = image:getWidth()
  local imh = image:getHeight()
  
  local quadt = {}
  
  for i = 1, #quads do
    quadt[#quadt + 1] = love.graphics.newQuad(
      quads[i][1],
      quads[i][2],
      quads[i][3],
      quads[i][4],
      imw, imh)
  end
  
  local instance = {
    time  = 0,
    index = 1,
    times = times,
    quads = quadt
  }
  
  return setmetatable(instance, mt)
end

function animation:reset()
  self.time = 0
  self.index = 1
end

function animation:update(dt)
  self.time = self.time + dt
  while self.time >= self.times[self.index] do
    self.time = self.time - self.times[self.index]
    
    -- TODO: Modulo
    self.index = (self.index % #self.times) + 1
  end
end

function animation:currentQuad()
  return self.quads[self.index]
end

return animation