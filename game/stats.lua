local stats = {}
local mt = {__index = stats}

function stats.new()
  local instance = {
    lives = 5,
    lifetime = 10,
    coins = 0  
  }
  return setmetatable(instance, mt)
end

function stats:update(dt)
  self.lifetime = self.lifetime - dt
end

function stats:lifeEnded()
  return self.lifetime <= 0
end

function stats:deductLife()
  self.lives    = self.lives - 1
  self.lifetime = 10
end

function stats:cap()
  self.lives = math.min(self.lives, 99999)
  self.lifetime = math.min(self.lifetime, 100)
end

return stats